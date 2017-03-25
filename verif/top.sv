module top(
    input  logic clk, reset,
    output logic [31:0] DataAdr,
    output logic [31:0] WriteData,
    output logic MemWrite
    );

    logic [31:0] PC, Instr, ReadData;
	logic [3:0] be;

    // instantiate processor and memories
    arm  arm (clk, reset, PC, Instr, MemWrite, be, DataAdr, WriteData, ReadData);
    
    imem imem(PC, Instr);
    
    ram ram(clk, MemWrite, be, DataAdr, WriteData, ReadData);
endmodule
