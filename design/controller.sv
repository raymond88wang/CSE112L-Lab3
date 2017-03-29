module controller(
	input logic clk, reset,
    input logic [31:0] Instr,
    input logic [3:0] ALUFlags,
    output logic [1:0] RegSrc,
    output logic RegWrite,
    output logic [1:0] ImmSrc,
    output logic ALUSrc,
	output logic ShifterSrc,
    output logic [3:0] ALUControl,
    output logic MemWrite, MemtoReg,
    output logic PCSrc,
	output logic [1:0] FlagWrite,
	output logic[3:0] be,
	output logic Branch);

    decoder dec(Instr[27:26], Instr[25:20], Instr[15:12], Instr[6:5], Instr[1:0], {Instr[7],Instr[4]},
        Branch, be, FlagWrite, PCSrc, RegW, MemW,
        MemtoReg, ALUSrc, ShifterSrc, ImmSrc, RegSrc, ALUControl);

endmodule
