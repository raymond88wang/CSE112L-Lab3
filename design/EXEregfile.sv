module EXregfile(
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
    input logic [31:0] ALUResult, WriteData, MEMResult,
    output logic [31:0] ALUResultE, WriteDataE, EXEResult);

    always_ff @(posedge clk)
		begin
			ALUOutM = ALUResultE;
			WriteDatao = WriteDataE;
			Resulto = Resulti;
		end
endmodule
