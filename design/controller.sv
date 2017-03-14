module controller(
	input logic clk, reset,
    input logic [31:5] Instr,
    input logic [3:0] ALUFlags,
    output logic [1:0] RegSrc,
    output logic RegWrite,
    output logic [1:0] ImmSrc,
    output logic ALUSrc,
	output logic ShifterSrc,
    output logic [1:0] ALUControl,
    output logic MemWrite, MemtoReg,
    output logic PCSrc,
	output logic[3:0] be);

    logic [1:0] FlagW;
    logic PCS, RegW, MemW;

    decoder dec(Instr[27:26], Instr[25:20], Instr[15:12], Instr[6:5],
        be, FlagW, PCS, RegW, MemW,
        MemtoReg, ALUSrc, ShifterSrc, ImmSrc, RegSrc, ALUControl);
    condlogic cl(clk, reset, Instr[31:28], ALUFlags,
        FlagW, PCS, RegW, MemW,
        PCSrc, RegWrite, MemWrite);

endmodule
