module arm(
    input logic clk, reset,
    output logic [31:0] PC,
    input logic [31:0] Instr,
    output logic MemWrite,
	output logic [3:0] be,
    output logic [31:0] ALUResult, WriteData,
    input logic [31:0] ReadData);

    logic [3:0] ALUFlags;
    logic RegWrite, ALUSrc, MemtoReg, PCSrc, ShifterSrc, Branch;
    logic [1:0] RegSrc, ImmSrc, FlagWrite;
	logic [3:0] ALUControl;

    controller c(clk, reset, Instr[31:0], ALUFlags,
        RegSrc, RegWrite, ImmSrc,
        ALUSrc, ShifterSrc, ALUControl,
        MemWrite, MemtoReg, PCSrc, FlagWrite, be, Branch);
    datapath dp(clk, reset,
        RegSrc, RegWrite, ImmSrc,
        ALUSrc, ShifterSrc, ALUControl,
        MemtoReg, PCSrc, FlagWrite, MemWrite, Branch,
        ALUFlags, PC, Instr[31:0],
        ALUResult, WriteData, ReadData);

endmodule
