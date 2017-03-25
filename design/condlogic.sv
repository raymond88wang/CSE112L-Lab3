module condlogic(
	input logic clk, reset,
    input logic [3:0] Cond,
    input logic [3:0] ALUFlags,
    input logic [1:0] FlagW,
    input logic PCSrcE, RegWriteE, MemWriteE, BranchE,
	input logic [3:0] ALUFlagsE,
    output logic PCSrcF, RegWriteF, MemWriteF, BranchF,
	output logic [3:0] ALUFlagsF
    );

    logic [1:0] FlagWrite;
    logic [3:0] Flags;
    logic CondEx;

    flopenr #(2)flagreg1(clk, reset, FlagWrite[1],
        ALUFlags[3:2], Flags[3:2]);
    flopenr #(2)flagreg0(clk, reset, FlagWrite[0],
        ALUFlags[1:0], Flags[1:0]);
    
    // write controls are conditional
    condcheck cc(Cond, Flags, CondEx);
    assign FlagWrite = FlagW & {2{CondEx}};
	assign PCSrcF = (PCSrcE & CondEx) | (BranchE & CondEx);
    assign RegWriteF = RegWriteE & CondEx;
    assign MemWriteF = MemWriteE & CondEx;
	assign BranchF = BranchE & CondEx;
endmodule

