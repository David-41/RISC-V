//-----------------------------------------------------------------------------
// Title         : Data Memory
//-----------------------------------------------------------------------------
// File          : RAM.sv
// Author        : David Ramón Alamán
// Created       : 22.09.2022
//-----------------------------------------------------------------------------

module RAM #(
    parameter DEPTH = 1024,
    parameter WORD_SIZE = 32
)(
    input logic clk, we,
    input logic[$clog2(DEPTH)-1:0] addr, 
    input logic[WORD_SIZE-1:0] dataIn,
    output logic[WORD_SIZE-1:0] dataOut
);
    logic[WORD_SIZE-1:0] ram[DEPTH-1:0];

    assign dataOut = ram[addr];

    always @(posedge clk) begin
        if(we) begin
            ram[addr] <= dataIn;
        end
    end
    
endmodule