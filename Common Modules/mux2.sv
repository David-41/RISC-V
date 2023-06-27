//-----------------------------------------------------------------------------
// Title         : Multiplexer 2 inputs
//-----------------------------------------------------------------------------
// File          : mux2.sv
// Author        : David Ramón Alamán
// Created       : 18.09.2022
//-----------------------------------------------------------------------------

module mux2 #(
    parameter WIDTH = 32
) (
    input logic[WIDTH-1:0] data1, data2,
    input logic s,
    output logic[WIDTH-1:0] dout
);
    
    assign dout = s ? data2 : data1;

endmodule