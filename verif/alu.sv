module alu(
		input logic [31:0] Rn, Src2,
		input logic [3:0] ALUControl,
		output logic [31:0] Rd,
		output logic [3:0] ALUFlags
    );


	always_comb 
	begin
		//FLAGS
		automatic logic overflow = 1'b0;
		automatic logic c_out = 1'b0;
		automatic logic negative = 1'b0;
		automatic logic zero = 1'b0;
		ALUFlags = 4'b0000;
		Rd = 32'b0;
		
		case(ALUControl)
		4'b0000 : // AND
			begin
				Rd = Rn & Src2;
			end
		  
		4'b0001 : // XOR
			begin
				Rd = Rn ^ Src2;
			end
		  
		4'b0010 : // SUB
			begin
				{c_out,Rd} = Rn - Src2;
				if (Rn[31] & ~Src2[31] & ~Rd[31])
					overflow = 1'b1;
				else if (~Rn[31] & Src2[31] & Rd[31])
					overflow = 1'b1;
				else
					overflow = 1'b0;
			end
		
		4'b0011 : // REVERSE SUB
			begin
				{c_out,Rd} = Src2 - Rn;
				if (Src2[31] & ~Rn[31] & ~Rd[31])
					overflow = 1'b1;
				else if (~Src2[31] & Rn[31] & Rd[31])
					overflow = 1'b1;
				else
					overflow = 1'b0;
			 end
		
		4'b0100 : // ADD
			begin
				{c_out,Rd} = Rn + Src2;
				if (Rn[31] & Src2[31] & ~Rd[31])
					overflow = 1'b1;
				else if (~Rn[31] & ~Src2[31] & Rd[31])
					overflow = 1'b1;
				else
					overflow = 1'b0;
			end
		
		4'b0101 : // ADD WITH CARRY
			begin
				c_out = Rn + Src2;
				{c_out, Rd} = Rn + Src2 + c_out;
				if (Rn[31] & Src2[31] & c_out & ~Rd[31])
					overflow = 1'b1;
				else if (~Rn[31] & ~Src2[31] & ~c_out & Rd[31])
					overflow = 1'b1;
				else
					overflow = 1'b0;
			end
		
		4'b0110 : // SUB WITH CARRY
			begin
				c_out = Rn - Src2;
				{c_out, Rd} = Rn - Src2 - c_out;
				if (Rn[31] & ~Src2[31] & ~c_out & ~Rd[31])
					overflow = 1'b1;
				else if (~Rn[31] & Src2[31] & c_out & Rd[31])
					overflow = 1'b1;
				else
					overflow = 1'b0;
			end
			
		4'b0111 : // REVERSE SUB WITH CARRY
			begin
				c_out = Src2 - Rn;
				{c_out, Rd} = Src2 - Rn - c_out;
				if (Src2[31] & ~Rn[31] & ~c_out & ~Rd[31])
					overflow = 1'b1;
				else if (~Src2[31] & Rn[31] & c_out & Rd[31])
					overflow = 1'b1;
				else
					overflow = 1'b0;
			end
		
		4'b1000 : // TEST
			begin
				Rd = Rn & Src2;
				zero = ~|Rd;
				negative = Rd[31];
				Rd = 32'b0;
			end
		
		4'b1001 : // TEST EQUIVALENCE
			begin
				Rd = Rn ^ Src2;
				zero = ~|Rd;
				negative = Rd[31];
				Rd = 32'b0;
			end

		4'b1010 : // COMPARE
			begin
				{c_out,Rd} = Rn - Src2;
				if (Rn[31] & ~Src2[31] & ~Rd[31])
					overflow = 1'b1;
				else if (~Rn[31] & Src2[31] & Rd[31])
					overflow = 1'b1;
				else
					overflow = 1'b0;
				zero = ~|Rd;
				negative = Rd[31];
				Rd = 32'b0;
			end
			
		4'b1011 : // COMPARE NEGATIVE
			begin
				{c_out,Rd} = Rn + Src2;
				if (Rn[31] & Src2[31] & ~Rd[31])
					overflow = 1'b1;
				else if (~Rn[31] & ~Src2[31] & Rd[31])
					overflow = 1'b1;
				else
					overflow = 1'b0;
				zero = ~|Rd;
				negative = Rd[31];
				Rd = 32'b0;
			end
			
		4'b1100 : // OR
			begin
				Rd = Rn | Src2;
			end
		
		4'b1101 : // SHIFTS
			begin
				Rd = Src2;
			end
		
		4'b1110 : // CLEAR
			begin
				Rd = Rn & ~Src2;
			end
		
		4'b1111 : // NOT
			begin
				Rd = ~Rn;
			end
		endcase
		zero = ~|Rd;
		negative = Rd[31];
		ALUFlags = {negative, zero, c_out, overflow};
	end
endmodule