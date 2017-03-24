module immshift(
    input logic [3:0] shift_imm,
	input logic [1:0] shift_control,
	input logic [31:0] Rm,
	output logic [31:0] Rd,
	output logic [3:0] ShifterFlags
);
    always_comb
	begin
	    automatic logic overflow = 1'b0;
		automatic logic carry_out = 1'b0;
		automatic logic negative = 1'b0;
		automatic logic zero = 1'b0;
		automatic logic c_flag = 1'b0;
		ShifterFlags = 4'b0000;
		Rd = 32'b0;
		
	    case(shift_control)
		2'b00: //LSL by immediate
		    begin
			    if (shift_imm == 0)
				begin
				    Rd = Rm;
					carry_out = c_flag;
			    end
				else
				begin
				    Rd = Rm << shift_imm;
					carry_out = Rm[32 - shift_imm];
				end
		    end
		2'b01: //LSR by immediate
		    begin
			    if (shift_imm == 0)
				begin
				    Rd = 32'b0;
					carry_out = Rm[31];
				end
				else
				begin
				    Rd = Rm >> shift_imm;
					carry_out = Rm[shift_imm - 1];
				end
		    end
		2'b10: //ASR by immediate
		    begin
			    if (shift_imm == 0)
				begin
				    if (Rm[31] == 0)
					begin
				        Rd = 32'b0;
						carry_out = Rm[31];
					end
					else
					begin
					    Rd = 32'hffffffff;
						carry_out = Rm[31];
					end
				end
				else
				begin
				    Rd = Rm >>> shift_imm;
					carry_out = Rm[shift_imm - 1];
				end
		    end
		2'b11: 
		    begin
			    if (shift_imm == 0) //RRX
				    Rd = (c_flag << 31) | (Rm >> 1);
				else //ROR by immediate
				begin
				    Rd = (Rm << shift_imm) | (Rm >> shift_imm);
					carry_out = Rm[shift_imm - 1];
				end
			end
		endcase
		zero = ~|Rd;
		negative = Rd[31];
		ShifterFlags = {negative, zero, carry_out, overflow};
	end
endmodule
