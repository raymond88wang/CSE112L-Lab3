module EXEregfile(
	input logic clk,
	//Controls
	input logic PCSrcF,
	input logic RegWriteF,
	input logic MemtoRegF,
	input logic MemWriteF,
	output logic PCSrcM,
	output logic RegWriteM,
	output logic MemtoRegM,
	output logic MemWriteM,
	
	//Relays
    input logic [31:0] ALUResult, 
	input logic [31:0] WriteData, 
	input logic [3:0] WA3E,
    output logic [31:0] ALUOutM, 
	output logic [31:0] WriteDataE, 
	output logic [3:0] WA3M);

    always_ff @(posedge clk)
		begin
			PCSrcM = PCSrcF;
			RegWriteM = RegWriteF;
			MemtoRegM = MemtoRegF;
			MemWriteM = MemWriteF;
			ALUOutM = ALUResult;
			WriteDataE = WriteData;
			WA3M = WA3E;
		end
endmodule
