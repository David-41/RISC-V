//-----------------------------------------------------------------------------
// Title         : Prescaler
//-----------------------------------------------------------------------------
// File          : Prescaler.sv
// Author        : David Ramón Alamán
// Created       : 24.12.2022
//-----------------------------------------------------------------------------

module Prescaler #(
    parameter INITIAL_VALUE = 1
)
(
    input logic clk, arst, en,
    input logic[31:0] new_value,
    output logic clk_en
);

logic[31:0] count, value;

always @(posedge clk or negedge arst) begin
    if(~arst) begin
        count <= 0;
        value <= INITIAL_VALUE;
    end

    else if (en) begin
        count <= count + 1;

        if(count === value) begin
            count <= 0;
            clk_en <= 1;
            value <= new_value;
        end
        else begin
            clk_en <= 0;
        end
    end
end

endmodule