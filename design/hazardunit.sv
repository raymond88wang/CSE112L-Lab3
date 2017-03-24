module HazardUnit(
	input logic Match_1E_M,
	input logic Match_1E_W,
	input logic Match_2E_M,
	input logic Match_2E_W,
	input logic Match_120D_E,
	input logic MemtoRegE,
	input logic RegWriteM,
	input logic RegWriteW,
	output logic [1:0] ForwardAE,
	output logic [1:0] ForwardBE,
	output logic [1:0] LDRstall,
	output logic [1:0] StallF,
	output logic [1:0] StallD,
	output logic [1:0] FlushE
);

	always_comb
	begin
	
		if (Match_1E_M * RegWriteM)
			ForwardAE = 10;
		else if (Match_1E_W * RegWriteW)
			ForwardAE = 01;
		else
			ForwardAE = 00;
	
		if (Match_2E_M * RegWriteM)
			ForwardBE = 10;
		else if (Match_2E_W * RegWriteW)
			ForwardBE = 01;
		else
			ForwardBE = 00;
		
		LDRstall = Match_120D_E * MemtoRegE;
		StallD = LDRstall;
		StallF = LDRstall;
		FlushE = LDRstall;
		
	end
	
endmodule