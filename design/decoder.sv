module decoder(
	input logic [1:0] Op,
    input logic [5:0] Funct,
    input logic [3:0] Rd,
	input logic [1:0] Op2,
	input logic [11:0] Src2
	output logic [3:0] be,
    output logic [1:0] FlagW,
    output logic PCS, RegW, MemW,
    output logic MemtoReg, ALUSrc, ShifterSrc,
    output logic [1:0] ImmSrc, RegSrc
	output logic [3:0] ALUControl);

    logic [10:0] controls;
    logic Branch, ALUOp;
    
    // Main Decoder
    always_comb
		casex(Op)
            2'b00:
				begin
					RegSrc = 2'b00;
					ImmSrc = 2'b00;
					ALUSrc = (Funct[5]) ? 1'b1 : 1'b0; // Immediate : Register
					MemtoReg = 1'b0;
					RegW = 1'b1;
					MemW = 1'b0;
					Branch = 1'b0;
					ALUOp = 1'b1;
					ShifterSrc = (Funct[4:1] == 4'b1101) ? 1'b1 : 1'b0;
					
					case(Op2)
						2'b01:
							if(~Funct[5])
								// STRH
								begin
									be = 4'b0011;
								end
							else
								// LDRH
								begin
									be = 4'b0010;
								end
						2'b10:
							// LDRSB
							begin
								be = 4'b0100;
							end
						2'b11:
							// LDRSH
							begin
								be = 4'b1000;
							end
				end
            2'b01:
				begin
					RegSrc = (Funct[0]) ? 2'b00 : 2'b10; // LDR : STR
					ImmSrc = 2'b01;
					ALUSrc = 1'b1;
					MemtoReg = 1'b1;
					RegW = 1'b1;
					MemW = 1'b0;
					Branch = 1'b0;
					ALUOp = 1'b0;
					ShifterSrc = 1'b0;
					be = (Funct[2]) ? 4'b0001 : 4'b0000; // {STRB, LDRB}, {STR, LDR}
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
					be = 4'b0000;
				end
            default: controls = 11'bx;
        endcase
    
    assign {RegSrc, ImmSrc, ALUSrc, MemtoReg,
        RegW, MemW, Branch, ALUOp, ShifterSrc} = controls;
    
    // ALU Decoder
    always_comb
        if (ALUOp)
			begin
				// update flags if S bit is set (C & V only for arith)
				FlagW[1] = Funct[0];
				FlagW[0] = Funct[0] &
					(ALUControl == 4'b0010 | ALUControl == 4'b0011 | ALUControl == 4'b0100 | ALUControl == 4'b0101 
					| ALUControl == 4'b0110 | ALUControl == 4'b0111 | ALUControl == 4'b1010 | ALUControl == 4'b1011);
					// {SUB, REVERSE SUB, ADD, ADD WITH CARRY, SUB WITH CARRY, REVERSE SUB WITH CARRY, COMPARE, COMPARE NEGATIVE}
			end 
        else 
			begin
				ALUControl = 4'b0100; // add for non-DP instructions
				FlagW = 2'b00; // don't update Flags
			end

    // PC Logic
    assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule