//-----------------------------------------------------------------------------
// Title         : Testbench PID with registers
//-----------------------------------------------------------------------------
// File          : tb_PID_Reg.sv
// Author        : David Ramón Alamán
// Created       : 24.12.2022
//-----------------------------------------------------------------------------

`timescale 1 ns / 1 ps

module tb_PID_Reg ();

    // Signals definition
    logic clk, rst, en, cs, write, read;
    logic[3:0] addr;
    logic[31:0] writeData, readData, control_bypass;
    int response = 0;

    PID_Reg #(
        .PRESCALER_DEFAULT_VALUE(1)
    ) dut (
        .clk(clk), 
        .chipSelect(cs), 
        .write(write), 
        .read(read), 
        .rst(rst), 
        .en(en),
        .addr(addr),
        .writeData(writeData), 
        .feedback_bypass(32'd19),
        .readData(readData),
        .control_bypass(control_bypass)
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
        writeData = 0;
        #7;
        rst = 1;
        en = 1;
        write = 1;
        cs = 1;
        addr = 0;
        writeData = 20;
        #10;
        addr = 1;
        writeData = 1;
        #10;
        addr = 2;
        writeData = -1;
        #10;
        addr = 4;
        writeData = response;
        #10;
        addr = 10;
        writeData = 15;
        #10;
        addr = 11;
        writeData = 5;
        #10;
        addr = 6;
        writeData = 1;
        while(response < 20) begin
            #10;
            read = 1;
            write = 0;
            addr = 12;
            response = response  + 1;
            #10;
            read = 0;
            write = 1;
            addr = 4;
            writeData = response;
        end
    end
endmodule