module regshift(
    input logic [31:0] Rs,
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
		2'b00: //LSL by register
		    begin
			    if (Rs[7:0] == 0)
				begin
				    Rd = Rm;
					carry_out = c_flag;
				end
				else if (Rs[7:0] < 32)
				begin
				    Rd = Rm << Rs[7:0];
					carry_out = Rm[32 - Rs[7:0]];
				end
				else if (Rs[7:0] == 32)
				begin
				    carry_out = Rm[0];
				    Rd = 32'b0;
				end
				else
				begin
				    carry_out = 1'b0;
				    Rd = 32'b0;
				end
		    end
		2'b01: //LSR by register
		    begin
			    if (Rs[7:0] == 0) begin
				    Rd = Rm;
					carry_out = c_flag;
					end
				else if (Rs[7:0] < 32) begin
				    Rd = Rm >> Rs[7:0];
					carry_out = Rm[Rs[7:0] - 1];
					end
				else if (Rs[7:0] == 32) begin
				    carry_out = Rm[31];
				    Rd = 32'b0;
					end
				else begin
				    carry_out = 1'b0;
				    Rd = 32'b0;
					end
		    end
		2'b10: //ASR by register
		    begin
			    if (Rs[7:0] == 0) begin
				    Rd = Rm;
					carry_out = c_flag;
					end
				else if (Rs[7:0] < 32) begin
				    Rd = Rm >>> Rs[7:0];
					carry_out = Rm[Rs[7:0] - 1];
					end
				else begin
					if (Rm[31] == 0)
					begin
				        Rd = 0;
						carry_out = Rm[31];
						end
					else
					begin
					    Rd = 32'hffffffff;
						carry_out = Rm[31];
						end
						end
		    end
		2'b11: //ROR by register
		    begin
			    if (Rs[7:0] == 0)
				begin
				    Rd = Rm;
					carry_out = c_flag;
					end
				else if (Rs[4:0] == 0) begin
				    Rd = Rm;
					carry_out = Rm[31];
					end
				else 
				begin
				    Rd = ((Rm << Rs[4:0]) | (Rm >> Rs[4:0]));
					carry_out = Rm[Rs[4:0] - 1];
					end
			end
		endcase
		zero = ~|Rd;
		negative = Rd[31];
		ShifterFlags = {negative, zero, carry_out, overflow};
	end
endmodule