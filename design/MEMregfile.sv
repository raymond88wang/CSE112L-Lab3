module MEMregfile(
    input logic clk,
    input logic [31:0] ReadData, 
	input logic [31:0] ALUOutM,
	input logic [3:0] WA3M,
    output logic [31:0] ReadDataW, 
	output logic [31:0] ALUOutW,
	output logic [3:0] WA3W);

    always_ff @(posedge clk)
		begin
			ReadDataW = ReadData;
			ALUOutW = ALUOutM;
			WA3W = WA3M;
		end
endmodule
