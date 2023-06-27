//-----------------------------------------------------------------------------
// Title         : Synchronous and Asynchronous Flip flop with enable
//-----------------------------------------------------------------------------
// File          : FlipFlop.sv
// Author        : David Ramón Alamán
// Created       : 16.10.2022
//-----------------------------------------------------------------------------

module FlipFlop #(
    parameter WIDTH = 32
) (
    input logic clk, en, srst, arst,
    input logic[WIDTH - 1:0] d,
    output logic[WIDTH - 1:0] q
);

    always_ff @(posedge clk or negedge arst) begin 
        if(~arst) q <= 0;     // Reset
		else if(~srst) q <= 0; // Reset
        else if(en) q <= d;  // If enable
    end   
endmodule