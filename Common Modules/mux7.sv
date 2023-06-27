//-----------------------------------------------------------------------------
// Title         : 7 Input multiplexer
//-----------------------------------------------------------------------------
// File          : mux7.sv
// Author        : David Ramón Alamán
// Created       : 25.05.2023
//-----------------------------------------------------------------------------

module mux7 #(
    parameter WIDTH = 32
) (
    input logic[WIDTH - 1:0] data0, data1, data2, data3, data4, data5, data6,
    input logic[2:0] s,
    output logic[WIDTH - 1:0] dout
);

    always_comb begin
        case (s)
            3'b000: dout = data0;
            3'b001: dout = data1;
            3'b010: dout = data2;
            3'b011: dout = data3;
            3'b100: dout = data4;
            3'b101: dout = data5;
            3'b110: dout = data6;
            default: dout = 'bx;        
        endcase
    end
    
endmodule