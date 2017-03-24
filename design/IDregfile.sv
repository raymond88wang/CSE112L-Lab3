module IDregfile(
    input logic clk,
    input logic [31:0] SrcA, 
	input logic [31:0] WriteData, 
	input logic [31:0] ExtImm, 
	input logic [31:0] Rs, 
	input logic [31:0] Resulti,
	input logic [3:0] WA3D,
    output logic [31:0] SrcAE, 
	output logic [31:0] SrcBE, 
	output logic [31:0] ExtImmE, 
	output logic [31:0] RsE, 
	output logic [31:0] Resulto,
	output logic [3:0] WA3E);

    always_ff @(posedge clk)
		begin
			SrcAE = SrcA;
			SrcBE = WriteData;
			WA3E = WA3D;
			ExtImmE = ExtImm;
			Resulto = Resulti;
		end
endmodule
