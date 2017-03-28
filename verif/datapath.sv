module datapath(
    input logic clk, reset,
    input logic [1:0] RegSrc,
    input logic RegWrite,
    input logic [1:0] ImmSrc,
    input logic ALUSrc,
	input logic ShifterSrc,
    input logic [3:0] ALUControl,
    input logic MemtoReg,
    input logic PCSrc,
	input logic [1:0] FlagWrite,
	input logic MemWrite,
	input logic Branch,
    output logic [3:0] ALUFlags,
    output logic [31:0] PC,
    input logic [31:0] InstrF,
    output logic [31:0] ALUResult, WriteData,
    input logic [31:0] ReadData);

	logic PCSrcE, RegWriteE, MemtoRegE, MemWriteE, BranchE, ALUSrcE, ShifterSrcE, 
	PCSrcF, RegWriteF, MemWriteF, BranchF, 
	PCSrcM, RegWriteM, MemtoRegM, MemWriteM, 
	PCSrcW, MemtoRegW;
		  
    logic [31:0] PCNext, PCPlus4, PCPlus8, InstrD, SrcAE, SrcAEt, SrcBE, ExtImmE, WriteDataE, WriteDataEt, WriteDataM, ALUResultM, ResultW, ReadDataW, ALUResultW, BranchResultW;
    logic [31:0] ExtImm, SrcA, Rd, Rs, BranchResult;
	logic [31:0] Result;
    logic [3:0] RA1, RA2, ShifterFlags, AFlags, BranchFlags, WA3E, WA3M, WA3W, ALUFlagsF, ALUControlE, CondE, ALUFlagsE;
	
	logic Match_1E_W, Match_1E_M, Match_2E_W, Match_2E_M, Match_12D_E;
	logic [1:0] ForwardAE, ForwardBE, LDRstall, StallF, StallD, FlushE, FlagWriteE;


    // next PC logic
    mux2 #(32) pcmux(PCPlus4, ResultW, PCSrcW, PCNext);
    flopr #(32) pcreg(clk, reset, PCNext, PC);
    adder #(32) pcadd1(1'b0, PC, 32'b100, PCPlus4);
    adder #(32) pcadd2(1'b0, PCPlus4, 32'b100, PCPlus8);
	IFregfile IFrf(clk, InstrF, InstrD);

    // register file logic
    mux2 #(4) ra1mux(InstrD[19:16], 4'b1111, RegSrc[0], RA1);
    mux2 #(4) ra2mux(InstrD[3:0], InstrD[15:12], RegSrc[1], RA2);
    regfile rf(clk, RegWriteW, RA1, RA2,
        WA3W, InstrD[11:8], ResultW, PCPlus8, PCPlus4,
        SrcA, WriteData, Rs);
    extend ext(InstrD[23:0], ImmSrc, ExtImm);
	IDregfile IDrf(clk, PCSrc, RegWrite, MemtoReg, MemWrite, ALUControl, Branch, ALUSrc, FlagWrite, InstrD[31:28], ALUFlagsF, ShifterSrc,
						PCSrcE, RegWriteE, MemtoRegE, MemWriteE, ALUControlE, BranchE, ALUSrcE, FlagWriteE, CondE, ALUFlagsE, ShifterSrcE,
						SrcA, WriteData, ExtImm, InstrD[15:12], 
						SrcAEt, WriteDataEt, ExtImmE, WA3E);
	shifter shifter(InstrD[25:0], WriteDataEt, Rs, Rd, ShifterFlags);
	condlogic cl(clk, reset, CondE, ALUFlags, FlagWriteE,
				PCSrcE, RegWriteE, MemWriteE, BranchE, ALUFlagsE, 
				PCSrcF, RegWriteF, MemWriteF, BranchF, ALUFlagsF);

    // ALU logic
	mux4 #(32) srcaemux(SrcAEt, ResultW, ALUResultM, ForwardAE, SrcAE);
	mux4 #(32) srcbemux(Rd, ResultW, ALUResultM, ForwardAE, WriteDataE);
    mux2 #(32) srcbmux(WriteDataE, ExtImm, ALUSrc, SrcBE);
    alu alu(SrcAE, SrcBE, ALUControlE, ALUResult, ALUFlags);
	//mux2 #(4) flagsmux(ShifterFlags, AFlags, ShifterSrcE, ALUFlags);
	EXEregfile EXErf(clk, PCSrcF, RegWriteF, MemtoRegE, MemWriteF,
						  PCSrcM, RegWriteM, MemtoRegM, MemWriteM,
						  ALUResult, WriteDataE, WA3E,
						  ALUResultM, WriteDataM, WA3M);
	
	immshift branchshift(4'b0010, 2'b00, ALUResultM, BranchResult, BranchFlags);
	mux2 #(32) branchmux(ReadData, BranchResult, BranchF, Result);
	MEMregfile MEMrf(clk, PCSrcM, RegWriteM, MemtoRegM,
						  PCSrcW, RegWriteW, MemtoRegW,
						  Result, ALUResultM, BranchResult, WA3M,
						  ReadDataW, ALUResultW, BranchResultW, WA3W);
    mux2 #(32) resultmux(ALUResultW, ReadDataW, MemtoRegW, ResultW);
	
	assign Match_1E_M = (SrcAE == WA3M)? 1:0;
	assign Match_1E_W = (SrcAE == WA3W)? 1:0;
	assign Match_2E_M = (WriteDataE == WA3M)? 1:0;
	assign Match_2E_W = (WriteDataE == WA3W)? 1:0;
	
	assign Match_12D_E = ((SrcAE == WA3E) | (WriteDataE == WA3E))? 1:0;
	
	HazardUnit hu(Match_1E_W, Match_1E_M, Match_2E_W, Match_2E_M, Match_12D_E, MemtoRegE, RegWriteM, RegWriteF, ForwardAE, ForwardBE, LDRstall, StallF, StallD, FlushE);
	
endmodule
