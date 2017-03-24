module EXEregfile(
    input logic clk,
    input logic [31:0] ALUResult, 
	input logic [31:0] WriteData, 
	input logic [31:0] MEMResult,
	input logic [3:0] WA3E,
    output logic [31:0] ALUOutM, 
	output logic [31:0] WriteDataE, 
	output logic [31:0] EXEResult,
	output logic [3:0] WA3M);

    always_ff @(posedge clk)
		begin
			ALUOutM = ALUResult;
			WriteDataE = WriteData;
			WA3M = WA3E;
			EXEResult = MEMResult;
		end
endmodule
