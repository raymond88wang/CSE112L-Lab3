module adder 
    #(parameter WIDTH = 8)
    (input logic sub,
	input logic [WIDTH-1:0] a, b,
    output logic [WIDTH-1:0] y);

	always_comb
	if(sub)
		begin
			y = a - b;
		end
	else
		begin
			y = a + b;
		end
endmodule
