module IDregfile(
    input logic clk,
	//Controls
	input logic PCSrc,
	input logic RegWrite,
	input logic MemtoReg,
	input logic MemWrite,
	input logic [3:0] ALUControl,
	input logic Branch,
	input logic ALUSrc,
	input logic [1:0] FlagWrite,
	input logic [3:0] Cond,
	input logic [3:0] ALUFlagsF,
	input logic ShifterSrc,
	output logic PCSrcE,
	output logic RegWriteE,
	output logic MemtoRegE,
	output logic MemWriteE,
	output logic [3:0] ALUControlE,
	output logic BranchE,
	output logic ALUSrcE,
	output logic [1:0] FlagWriteE,
	output logic [3:0] CondE,
	output logic [3:0] ALUFlagsE,
	output logic ShifterSrcE,
	
	//Relays
    input logic [31:0] SrcA,
	input logic [31:0] WriteData, 
	input logic [31:0] ExtImm, 
	//input logic [31:0] Rs,
	input logic [3:0] WA3D,
    output logic [31:0] SrcAE, 
	output logic [31:0] SrcBE, 
	output logic [31:0] ExtImmE, 
	//output logic [31:0] RsE,
	output logic [3:0] WA3E);

    always_ff @(posedge clk)
		begin
			//Controls
			PCSrcE <= PCSrc;
			RegWriteE <= RegWrite;
			MemtoRegE <= MemtoReg;
			MemWriteE <= MemWrite;
			ALUControlE <= ALUControl;
			BranchE <= Branch;
			ALUSrcE <= ALUSrc;
			FlagWriteE <= FlagWrite;
			CondE <= Cond;
			ALUFlagsE <= ALUFlagsF;
			
			//Relays
			SrcAE <= SrcA;
			SrcBE <= WriteData;
			WA3E <= WA3D;
			ExtImmE <= ExtImm;
		end
endmodule
