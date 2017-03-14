module mux4 
    #(parameter WIDTH = 8)
    (input logic [WIDTH-1:0] d0, d1, d2, d3,
    input logic [1:0] s,
    output logic [WIDTH-1:0] y);

	always_comb
	case(s)
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
		2'b11:
			begin
				assign y = d3;
			end
	endcase
endmodule
