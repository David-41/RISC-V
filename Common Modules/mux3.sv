//-----------------------------------------------------------------------------
// Title         : 3 Input multiplexer
//-----------------------------------------------------------------------------
// File          : mux3.sv
// Author        : David Ramón Alamán
// Created       : 03.10.2022
//-----------------------------------------------------------------------------

module mux3 #(
    parameter WIDTH = 32
) (
    input logic[WIDTH - 1:0] data0, data1, data2,
    input logic[1:0] s,
    output logic[WIDTH - 1:0] dout
);

    always_comb begin
        case (s)
            2'b00: dout = data0;
            2'b01: dout = data1;
            2'b10: dout = data2;
            default: dout = 'bx;        
        endcase
    end
    
endmodule