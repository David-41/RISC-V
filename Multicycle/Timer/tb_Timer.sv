//-----------------------------------------------------------------------------
// Title         : Testbench Timer with registers
//-----------------------------------------------------------------------------
// File          : tb_Timer.sv
// Author        : David Ramón Alamán
// Created       : 24.12.2022
//-----------------------------------------------------------------------------

`timescale 1 ns / 1 ps

module tb_Timer ();

    // Signals definition
    logic clk, rst, en, cs, write, read;
    logic[4:0] addr;
    logic[1:0] pwm1out, pwm2out;
    logic[31:0] writeData, readData, compare1, compare2;

    Timer /*#(
        .PRESCALER_DEFAULT_VALUE(1)
    )*/ dut (
        .clk(clk), 
        .chipSelect(cs), 
        .write(write), 
        .read(read), 
        .rst(rst), 
        .en(en),
        .addr(addr),
        .writeData(writeData), 
        .bypass1(compare1),
        .bypass2(compare2),
        .pwm1out(pwm1out),
        .pwm2out(pwm2out),
        .readData(readData)
    );

    // Generate clock
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // Initialization
    initial begin
        en = 0;
        rst = 0;
        cs = 0;
        write = 0;
        read = 0;
        addr = 0;
        compare1 = 2;
        compare2 = 8;
        writeData = 0;
        #7;
        en = 1;
        rst = 1;
        cs = 1;
        write = 1;
        writeData = 10;
        addr = 1;
        #10;
        addr = 2; 
        writeData = 1;
        #200;
        writeData = 0;
        #10; 
        writeData = 0;
        addr = 0;
        #10;
        addr = 4;
        writeData = 4;
        #10;
        addr = 2;
        writeData = 1;
        #520;
        addr = 2;
        writeData = 0;
        #10;
        addr = 4;
        writeData = 0;
        #10;
        addr = 0;
        writeData = 0;
        #10;
        addr = 8;
        writeData = 32'b0111;
        #10;
        addr = 6;
        writeData = 5;
        #10;
        addr = 7;
        #10;
        addr = 2;
        writeData = 1;
        #100;
        writeData = 1;
        addr = 5;
        #10;
        addr = 9;
        writeData = 1; 
    end
endmodule