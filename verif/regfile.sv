module regfile(
    input logic clk,
    input logic we3,
    input logic [3:0] ra1, ra2, wa3, ra4,
    input logic [31:0] wd3, r15, r14,
    output logic [31:0] rd1, rd2, rs);


    logic [31:0] rf[14:0];


    // three ported register file
    // read two ports combinationally
    // write third port on rising edge of clock
    // register 15 reads PC + 8 instead


    always_ff @(posedge clk)
        if (we3) begin
			if(ra1 == 4'b1111) begin
				rf[13] <= r14;
			end
			else begin
				rf[wa3] <= wd3;
			end
		end

    assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
    assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];
	assign rs = (ra4 == 4'b1111) ? r15 : rf[ra4];
endmodule
