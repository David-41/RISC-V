//-----------------------------------------------------------------------------
// Title         : Adder
//-----------------------------------------------------------------------------
// File          : Adder.sv
// Author        : David Ramón Alamán
// Created       : 03.10.2022
//-----------------------------------------------------------------------------

module Adder #(
    parameter WIDTH = 32
) (
    input logic[WIDTH - 1:0] in1, in2,
    output logic[WIDTH - 1:0] s
);

    assign s = in1 + in2;
    
endmodule