//-----------------------------------------------------------------------------
// Title         : Memory
//-----------------------------------------------------------------------------
// File          : Memory.sv
// Author        : David Ramón Alamán
// Created       : 22.09.2022
//-----------------------------------------------------------------------------

module Memory #(
    parameter DEPTH = 10,
    parameter WORD_SIZE = 32,
    parameter INITIALIZE = 0,
    parameter FILE = "Memory.txt"
)(
    input logic clk, we, read, cs,
    input logic[$clog2(DEPTH)-1:0] addr, 
    input logic[WORD_SIZE-1:0] dataIn,
    output logic[WORD_SIZE-1:0] dataOut
);
    logic[WORD_SIZE-1:0] memory[DEPTH-1:0];

    initial begin
        if(INITIALIZE == 1'b1) begin
            $readmemh(FILE, memory);
        end
    end

    always @(posedge clk) begin
        if(cs) begin
            if(we) begin
                memory[addr] <= dataIn;
            end
            else if(read) begin
                dataOut <= memory[addr];
            end
        end
    end
endmodule