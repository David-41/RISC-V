//-----------------------------------------------------------------------------
// Title         : Multiplexer 10 inputs
//-----------------------------------------------------------------------------
// File          : mux10.sv
// Author        : David Ramón Alamán
// Created       : 18.09.2022
//-----------------------------------------------------------------------------

module mux10 (
    input logic[31:0] data[9:0],
    input logic[3:0] s,
    output logic[31:0] dout
);
    
    always_comb begin
        if(s < 10) begin
            dout = data[s];
        end
        else begin
            dout = 32'bx;
        end
    end 
endmodule