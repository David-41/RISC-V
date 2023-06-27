//-----------------------------------------------------------------------------
// Title         : 7-segment 6-digit display decoder
//-----------------------------------------------------------------------------
// File          : Hex7Segments.sv
// Author        : David Ramón Alamán
// Created       : 10.11.2022
//-----------------------------------------------------------------------------

module Hex7Segments (
    input logic clk, chipSelect, write, read, rst,
    input logic[31:0] writeData,
    output logic[6:0] hex5, hex4, hex3, hex2, hex1, hex0,
    output logic[31:0] readData
);
    logic[31:0] register; 

    always_ff @(posedge clk or negedge rst) begin
        if(!rst) begin
            register = 32'd0;
        end
        else begin
            if(chipSelect) begin
                if(write) begin
                    register <= writeData;
                end
                else if(read) begin
                    readData <= register;
                end
            end
        end
    end

    hex7seg #(.INVERT(1'b0)) disp0 (
        .inhex(register[3:0]),
        .out7seg(hex0)
    );

    hex7seg #(.INVERT(1'b0)) disp1 (
        .inhex(register[7:4]),
        .out7seg(hex1)
    );

    hex7seg #(.INVERT(1'b0)) disp2 (
        .inhex(register[11:8]),
        .out7seg(hex2)
    );

    hex7seg #(.INVERT(1'b0)) disp3 (
        .inhex(register[15:12]),
        .out7seg(hex3)
    );

    hex7seg #(.INVERT(1'b0)) disp4 (
        .inhex(register[19:16]),
        .out7seg(hex4)
    );

    hex7seg #(.INVERT(1'b0)) disp5 (
        .inhex(register[23:20]),
        .out7seg(hex5)
    );
    
endmodule

module hex7seg #(
    parameter INVERT = 0
)(
    input [3:0] inhex,
    output [6:0] out7seg
);

    logic [6:0] out7seg_aux;

    always_comb begin
        case (inhex)
            4'h0: out7seg_aux = 7'h3F;
            4'h1: out7seg_aux = 7'h06; 
            4'h2: out7seg_aux = 7'h5B; 
            4'h3: out7seg_aux = 7'h4F;
            4'h4: out7seg_aux = 7'h66; 
            4'h5: out7seg_aux = 7'h6D; 
            4'h6: out7seg_aux = 7'h7D; 
            4'h7: out7seg_aux = 7'h07;
            4'h8: out7seg_aux = 7'h7F;
            4'h9: out7seg_aux = 7'h67; 
            4'hA: out7seg_aux = 7'h77; 
            4'hB: out7seg_aux = 7'h7C;
            4'hC: out7seg_aux = 7'h39;
            4'hD: out7seg_aux = 7'h5E; 
            4'hE: out7seg_aux = 7'h79; 
            4'hF: out7seg_aux = 7'h71; 
            default: out7seg_aux = 7'h7F; 
        endcase  
    end   

    assign out7seg = INVERT ? ~(out7seg_aux) : out7seg_aux;

endmodule