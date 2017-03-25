module mux4 
    #(parameter WIDTH = 8)
    (input logic [WIDTH-1:0] d0, d1, d2,
    input logic [1:0] s,
    output logic [WIDTH-1:0] y);

	always_comb
	begin
		case (s)
			2'b00:
				begin
					assign y = d0;
				end
			2'b01:
				begin
					assign y = d1;
				end
			2'b10:
				begin
					assign y = d2;
				end
		endcase
	end
			
endmodule
