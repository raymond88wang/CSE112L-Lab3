module decoder(
	input logic [1:0] Op,
    input logic [5:0] Funct,
    input logic [3:0] Rd,
	input logic [1:0] Op2,
	input logic [1:0] ByteSel,
	output logic Branch,
	output logic [3:0] be,
    output logic [1:0] FlagW,
    output logic PCS, RegW, MemW,
    output logic MemtoReg, ALUSrc, ShifterSrc,
    output logic [1:0] ImmSrc, RegSrc,
	output logic [3:0] ALUControl);


    logic ALUOp;
    
    // Main Decoder
    always_comb
		begin
			casex(Op)
				2'b00:
					begin
						RegSrc = 2'b10;
						ImmSrc = 2'b00;
						ALUSrc = Funct[2]; // Immediate : Register
						MemtoReg = 1'b0;
						RegW = 1'b1; // {LDRH, LDRSB, LDRSH} : STRH
						MemW = 1'b0; // {LDRH, LDRSB, LDRSH} : STRH
						Branch = 1'b0;
						ALUOp = 1'b1;
						ShifterSrc = (Funct[4:1] == 4'b1101) ? 1'b1 : 1'b0;
						ALUControl = Funct[4:1];
						be = 4'bx;
						
						case(Op2)
							2'b01:
								if(~Funct[5])
									// STRH
									begin
										be = 4'b0100;
										RegW = 1'b0;
										MemW = 1'b1;
									end
								else
									// LDRH
									begin
										be = {2'b01, ByteSel};
										MemtoReg = 1'b1;
									end
							2'b10:
								// LDRSB
								begin
									be = (Funct[4:1] == 4'b1101) ? 4'bx : {2'b10, ByteSel};
									MemtoReg = 1'b1;
								end
							2'b11:
								// LDRSH
								begin
									be = {2'b11, ByteSel[1], 1'b0};
									MemtoReg = 1'b1;
								end
						endcase
						
						FlagW[1] = Funct[0];
						FlagW[0] = Funct[0] &
							(ALUControl == 4'b0010 | ALUControl == 4'b0011 | ALUControl == 4'b0100 | ALUControl == 4'b0101 
							| ALUControl == 4'b0110 | ALUControl == 4'b0111 | ALUControl == 4'b1010 | ALUControl == 4'b1011);
							// {SUB, REVERSE SUB, ADD, ADD WITH CARRY, SUB WITH CARRY, REVERSE SUB WITH CARRY, COMPARE, COMPARE NEGATIVE}
					end
				2'b01:
					begin
						RegSrc = Funct[0] ? 2'b00 : 2'b01; // LDR : STR
						ImmSrc = {2'b0, ~Funct[5]};
						ALUSrc = ~Funct[5];
						MemtoReg = 1'b1;
						RegW = Funct[0]; // LDR : STR
						MemW = ~Funct[0]; // LDR : STR
						Branch = 1'b0;
						ALUOp = 1'b0;
						ShifterSrc = 1'b0;
						be = Funct[2] ? {2'b00, ByteSel} : 4'b1111; // {STRB, LDRB}, {STR, LDR}
						
						ALUControl = 4'b0100; // add for non-DP instructions
						FlagW = 2'b00; // don't update Flags
					end
				2'b10: 
					// {B, BL}
					begin
						RegSrc = 2'b01;
						ImmSrc = 2'b10;
						ALUSrc = 1'b1;
						MemtoReg = 1'b0;
						RegW = 1'b0;
						MemW = 1'b0;
						Branch = 1'b1;
						ALUOp = 1'b0;
						ShifterSrc = 1'b0;
						be = 4'bx;
						
						ALUControl = 4'b0100; // add for non-DP instructions
						FlagW = 2'b00; // don't update Flags
					
						if(Funct[4])
							// BL
							begin
								RegW = 1'b1;
							end
					end
			endcase
		end

    // PC Logic
    assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule