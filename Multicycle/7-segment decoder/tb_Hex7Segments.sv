//-----------------------------------------------------------------------------
// Title         : Testbench Timer with registers
//-----------------------------------------------------------------------------
// File          : tb_Timer.sv
// Author        : David Ramón Alamán
// Created       : 12.11.2022
//-----------------------------------------------------------------------------

module tb_Hex7Segments ();

    // Signals definition
    logic clk, rst, cs, write, read;
    logic[6:0] hex5, hex4, hex3, hex2, hex1, hex0;
    logic[31:0] writeData, readData;

    Hex7Segments dut(
        .clk(clk), 
        .chipSelect(cs), 
        .write(write), 
        .read(read), 
        .rst(rst),
        .writeData(writeData),
        .hex5(hex5), 
        .hex4(hex4), 
        .hex3(hex3), 
        .hex2(hex2), 
        .hex1(hex1), 
        .hex0(hex0),
        .readData(readData)
    );

    // Generate clock
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // Initialization
    initial begin
        rst = 0;
        cs = 0;
        write = 0;
        read = 0;
        writeData = 0;
        #7;
        rst = 1;
        cs = 1;
        write = 1;
        writeData = 32'h00654321;
    end
endmodule