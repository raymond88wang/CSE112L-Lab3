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
	input logic MemWrite,
	input logic Branch,
    output logic [3:0] ALUFlags,
    output logic [31:0] PC,
    input logic [31:0] InstrIn,
    output logic [31:0] ALUResult, WriteDataE,
    input logic [31:0] ReadData);


    logic [31:0] PCNext, PCPlus4, PCPlus8, InstrOut;
    logic [31:0] ExtImm, ExtImmE, SrcA, SrcB, SrcAE, SrcBE, Rd, PCPlus8Minus4, Rs, RsE, BranchResult, dmemResult, WriteData;
	logic [31:0] Result, MEMResult, EXEResult, IDResult, ResultToPc, ALUOutM, ALUOutW, ReadDataW;
    logic [3:0] RA1, RA2, ShifterFlags, DummySF, AFlags, WA3E, WA3M, WA3W;
	


    // next PC logic
    mux2 #(32) pcmux(PCPlus4, Result, PCSrc, PCNext);
    flopr #(32) pcreg(clk, reset, PCNext, PC);
    adder #(32) pcadd1(1'b0, PC, 32'b100, PCPlus4);
    adder #(32) pcadd2(1'b0, PCPlus4, 32'b100, PCPlus8);
	adder #(32) bladd(InstrOut[24],PCPlus8, 32'b100, PCPlus8Minus4);
	IFregfile IFrf(clk, InstrIn, IDResult, InstrOut, ResultToPC);

    // register file logic
    mux2 #(4) ra1mux(InstrOut[19:16], 4'b1111, RegSrc[0], RA1);
    mux2 #(4) ra2mux(InstrOut[3:0], InstrOut[15:12], RegSrc[1], RA2);
    regfile rf(clk, RegWrite, RA1, RA2,
        WA3W, InstrOut[11:8], Result, PCPlus8, PCPlus8Minus4,
        SrcA, WriteData, Rs);
    mux2 #(32) resmux(ALUResult, ReadData, MemtoReg, Result);
    extend ext(InstrOut[23:0], ImmSrc, ExtImm);
	IDregfile IDrf(clk, SrcA, WriteData, InstrOut[15:12], ExtImm, Rs, EXEResult, RA1E, WriteDataE, WA3E, ExtImmE, RsE, IDResult);

    // ALU logic
	shifter shifter(InstrOut[25:0], WriteDataE, RsE, Rd, ShifterFlags);
    mux2 #(32) srcbmux(Rd, ExtImmE, ALUSrc, SrcBE);
    alu alu(SrcAE, SrcBE, ALUControl, ALUResult, AFlags);
	mux2 #(4) flagsmux(ShifterFlags, AFlags, ShifterSrc, ALUFlags);
	EXEregfile EXErf(clk, ALUResult, WriteDataE, MEMResult, WA3E, ALUOutM, WriteDataE, EXEResult, WA3M);
	
	MEMregfile MEMrf(clk, ReadData, ALUOutM, WA3M, ReadDataW, ALUOutW, WA3W);
	mux2 #(32) resultmux(ReadDataW, ALUOutW, MemtoReg, Result);
	
	immshift branchshift(4'b0010, 2'b00, ALUResult, BranchResult, DummySF);
	mux2 #(32) branchmux(Result, BranchResult, Branch, Result);
endmodule
