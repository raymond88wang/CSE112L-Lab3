module arm(
    input logic clk, reset,
    output logic [31:0] PC,
    input logic [31:0] Instr,
    output logic MemWrite,
	output logic [3:0] be,
    output logic [31:0] ALUResult, WriteData,
    input logic [31:0] ReadData);

    logic [3:0] ALUFlags;
    logic RegWrite, ALUSrc, MemtoReg, PCSrc, ShifterSrc;
    logic [1:0] RegSrc, ImmSrc, ALUControl;

    controller c(clk, reset, Instr[31:5], ALUFlags,
        RegSrc, RegWrite, ImmSrc,
        ALUSrc, ShifterSrc, ALUControl,
        MemWrite, MemtoReg, PCSrc, be);
    datapath dp(clk, reset,
        RegSrc, RegWrite, ImmSrc,
        ALUSrc, ShifterSrc, ALUControl,
        MemtoReg, PCSrc, MemWrite,
        be, ALUFlags, PC, Instr,
        ALUResult, WriteData, ReadData);

endmodule
