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

	logic PCSrcE, RegWriteE, MemtoRegE, MemWriteE, ALUControlE, BranchE, ALUSrcE, FlagWriteE, CondE, ALUFlagsE, ShifterSrcE,
		  SrcAE, SrcBE, ExtImmE, , WA3E
		  SrcBF, PCSrcF, RegWriteF, MemWriteF, BranchF, ALUFlagsF,
		  PCSrcM, RegWriteM, MemtoRegM, MemWriteM, ALUResultM, WriteDataM, WA3M,
		  ResultW, ReadDataW, ALUResultW, BranchResultW, MemtoRegW, WA3W;
		  
    logic [31:0] PCNext, PCPlus4, PCPlus8, InstrD;
    logic [31:0] ExtImm, SrcA, Rd, Rs, BranchResult;
	logic [31:0] Result;
    logic [3:0] RA1, RA2, ShifterFlags, AFlags, BranchFlags;
	


    // next PC logic
    mux2 #(32) pcmux(PCPlus4, ResultToPc, PCSrcW, PCNext);
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
	//IDregfile IDrf(clk, PCSrc, RegWrite, MemtoReg, MemWrite, ALUControl, Branch, ALUSrc, FlagWrite, InstrD[31:28], ALUFlagsF, ShifterSrc,
						PCSrcE, RegWriteE, MemtoRegE, MemWriteE, ALUControlE, BranchE, ALUSrcE, FlagWriteE, CondE, ALUFlagsE, ShifterSrcE,
						//SrcA, WriteData, ExtImm, , InstrD[15:12], 
						//SrcAE, SrcBE, ExtImmE, , WA3E);
	//shifter shifter(InstrOut[25:0], WriteData, Rs, Rd, ShifterFlags);
	condlogic cl(clk, reset, CondE, ALUFlags, FlagWriteE,
				PCSrcE, RegWriteE, MemWriteE, BranchE, ALUFlagsE, 
				PCSrcF, RegWriteF, MemWriteF, BranchF, ALUFlagsF);

    // ALU logic
    mux2 #(32) srcbmux(Rd, ExtImm, ALUSrc, SrcBF);
    alu alu(SrcAE, SrcBF, ALUControlE, ALUResult, AFlags);
	//mux2 #(4) flagsmux(ShifterFlags, AFlags, ShifterSrcE, ALUFlags);
	EXEregfile EXErf(clk, PCSrcF, RegWriteF, MemtoRegE, MemWriteF,
						  PCSrcM, RegWriteM, MemtoRegM, MemWriteM,
						  ALUResult, WriteData, WA3E,
						  ALUResultM, WriteDataM, WA3M);
	
	immshift branchshift(4'b0010, 2'b00, ALUResultM, BranchResult, BranchFlags);
	mux2 #(32) branchmux(ReadData, BranchResult, BranchF, Result);
	MEMregfile MEMrf(clk, PCSrcM, RegWriteM, MemtoRegM,
						  PCSrcW, RegWriteW, MemtoRegW,
						  Result, ALUResultM, BranchResult, WA3M,
						  ReadDataW, ALUResultW, BranchResultW, WA3W);
    mux2 #(32) resultmux(ALUResultW, ReadDataW, MemtoRegW, ResultW);
endmodule
