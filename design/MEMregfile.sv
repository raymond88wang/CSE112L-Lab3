module MEMregfile(
    input logic clk,
	//Controls
	input logic PCSrcM,
	input logic RegWriteM,
	input logic MemtoRegM,
	output logic PCSrcW,
	output logic RegWriteW,
	output logic MemtoRegW,
	
	//Relays
    input logic [31:0] Result, 
	input logic [31:0] ALUResultM,
	input logic [31:0] BranchResult,
	input logic [3:0] WA3M,
    output logic [31:0] ReadDataW, 
	output logic [31:0] ALUResultW,
	output logic [31:0] BranchResultW,
	output logic [3:0] WA3W);

    always_ff @(posedge clk)
		begin
			PCSrcW <= PCSrcM;
			RegWriteW <= RegWriteM;
			MemtoRegW <= MemtoRegM;
			ReadDataW <= Result;
			ALUResultW <= ALUResultM;
			BranchResultW <= BranchResult;
			WA3W <= WA3M;
		end
endmodule
