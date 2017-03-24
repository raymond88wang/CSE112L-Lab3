module IFregfile(
    input logic clk,
    input logic [31:0] InstrF, 
	input logic [31:0] Resulti,
    output logic [31:0] InstrD, 
	output logic [31:0] Resulto);

    always_ff @(posedge clk)
		begin
			InstrD = InstrF;
			Resulto = Resulti;
		end
endmodule
