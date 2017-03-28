module shifter(
    input logic [25:0] Instr,
	input logic [31:0] Rm,
	input logic [31:0] Rs,
	output logic [31:0] Rd,
	output logic [3:0] ShifterFlags
);
	logic [31:0] Rm1, Rd1, Rm2, Rd2;
	logic [3:0] flags1, flags2;
	
    regshift regshift(Rs, Instr[6:5], Rm1, Rd1, flags1);
	immshift immshift(Instr[11:8], Instr[6:5], Rm2, Rd2, flags2);
	
	always_comb
	begin
	automatic logic overflow = 1'b0;
	automatic logic c_out = 1'b0;
	automatic logic negative = 1'b0;
	automatic logic zero = 1'b0;

    if (Instr[25] || ~Instr[11:4])
	    begin
	    Rd = Rm;
		zero = ~|Rd;
		negative = Rd[31];
		ShifterFlags = {negative, zero, c_out, overflow};
		end
	else
	    if (Instr[4])
		begin
		    Rd = Rm1;
	        ShifterFlags = flags1;
		end
		else
		begin
	        Rd = Rm2;
	        ShifterFlags = flags2;
		end
    end
endmodule