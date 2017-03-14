module datapath(
    input logic clk, reset,
    input logic [1:0] RegSrc,
    input logic RegWrite,
    input logic [1:0] ImmSrc,
    input logic ALUSrc,
	input logic ShifterSrc,
    input logic [1:0] ALUControl,
    input logic MemtoReg,
    input logic PCSrc,
	input logic MemWrite,
    output logic [3:0] ALUFlags,
    output logic [31:0] PC,
    input logic [31:0] Instr,
    output logic [31:0] ALUResult, WriteData,
    input logic [31:0] ReadData);


    logic [31:0] PCNext, PCPlus4, PCPlus8;
    logic [31:0] ExtImm, SrcA, SrcB, Result, Rd, PCPlus4toR14, Rs;
    logic [3:0] RA1, RA2, ShifterFlags, AFlags;
	


    // next PC logic
    mux2 #(32) pcmux(PCPlus4, Result, PCSrc, PCNext);
    flopr #(32) pcreg(clk, reset, PCNext, PC);
    adder #(32) pcadd1(PC, 32'b100, PCPlus4);
    adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);


    // register file logic
    mux2 #(4) ra1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1);
    mux2 #(4) ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2);
	mux4 #(32) r14mux(32'bx, 32'bx, 32'bx, PCPlus4, Instr[25:24], PCPlus4toR14);
    regfile rf(clk, RegWrite, RA1, RA2,
        Instr[15:12], Instr[11:8], Result, PCPlus8, PCPlus4toR14,
        SrcA, WriteData, Rs);
    mux2 #(32) resmux(ALUResult, ReadData, MemtoReg, Result);
    extend ext(Instr[23:0], ImmSrc, ExtImm);
	shifter shifter(Instr[25:0], WriteData, Rs, Rd, ShifterFlags);

    // ALU logic
    mux2 #(32) srcbmux(Rd, ExtImm, ALUSrc, SrcB);
    alu alu(SrcA, SrcB, ALUControl, ALUResult, AFlags);
	mux2 #(4) flagsmux(ShifterFlags, AFlags, ShifterSrc, ALUFlags);
	
	mux2 #(32) resultmux(ReadData, ALUResult, MemtoReg, Result);
endmodule
