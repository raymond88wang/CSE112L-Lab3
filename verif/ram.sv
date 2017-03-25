module ram(
	input logic clk ,
	input logic we ,
	input logic [3:0] be , // Byte - enable
	input logic [31:0] addr ,
	input logic [31:0] dataI ,
	output logic [31:0] dataO);
	
	logic [31:0] RAM[512:0];
	logic [31:0] dataInMem;
	
	always @ (negedge clk)
		begin
			dataInMem[31:0] <= RAM[addr[31:2]];
		end
	
	always_comb
		begin
			if(~we)
				begin
					case(be[3:2])
						2'b00:
							// LDRB
							begin
								case(be[1:0])
									2'b00:
										begin
											dataO = {{24{1'b0}}, dataInMem[7:0]};
										end
									2'b01:
										begin
											dataO = {{24{1'b0}}, dataInMem[15:8]};
										end
									2'b10:
										begin
											dataO = {{24{1'b0}}, dataInMem[23:16]};
										end
									2'b11:
										begin
											dataO = {{24{1'b0}}, dataInMem[31:24]};
										end
								endcase
							end
						2'b01:
							// LDRH
							begin
								if(be[1])								
									begin
										dataO = {{24{1'b0}}, dataInMem[31:16]};
									end
								else
									begin
										dataO = {{24{1'b0}}, dataInMem[15:0]};
									end
							end
						2'b10:
							// LDRSB
							begin
								case(be[1:0])
									2'b00:
										begin
											dataO = dataInMem[7] ? {{24{1'b1}}, dataInMem[7:0]} : {{24{1'b0}}, dataInMem[7:0]};
										end
									2'b01:
										begin
											dataO = dataInMem[15] ? {{24{1'b1}}, dataInMem[15:8]} : {{24{1'b0}}, dataInMem[15:8]};
										end
									2'b10:
										begin
											dataO = dataInMem[23] ? {{24{1'b1}}, dataInMem[23:16]} : {{24{1'b0}}, dataInMem[23:16]};
										end
									2'b11:
										begin
											dataO = dataInMem[31] ? {{24{1'b1}}, dataInMem[31:24]} : {{24{1'b0}}, dataInMem[31:24]};
										end
								endcase
							end
						2'b11:
							// LDRSH
							begin
								if(be[1])
									begin
										dataO = dataInMem[31] ? {{16{1'b1}}, dataInMem[31:16]} : {{16{1'b0}}, dataInMem[31:16]};
									end
								else
									begin
										dataO = dataInMem[15] ? {{16{1'b1}}, dataInMem[15:0]} : {{16{1'b0}}, dataInMem[15:0]};
									end
								if(be[1:0] == 2'b11)
									// LDR
									begin
										dataO = dataInMem;
									end
							end
					endcase
				end
		end
			
	always @ (posedge clk)
		begin
			if (we) 
				begin
					case(be[3:2])
						2'b00:
							// STRB
							begin
								RAM[addr[31:2]] <= {dataInMem[31:8], dataI[7:0]};
							end
						2'b01:
							// STRH
							begin
								RAM[addr[31:2]] <= {dataInMem[31:16], dataI[15:0]};
							end
						2'b11:
							// STR
							begin
								RAM[addr[31:2]] <= dataI;
							end
					endcase
				end
		end
endmodule