//-----------------------------------------------------------------------------
// Title         : Parameterised full adder
//-----------------------------------------------------------------------------
// File          : fullAdder.sv
// Author        : David Ramón Alamán
// Created       : 18.09.2022
//-----------------------------------------------------------------------------

module fullAdder #(
    parameter WIDTH = 32
) (
    input logic[WIDTH-1:0] operand1, operand2,
    input logic cin,
    output logic[WIDTH-1:0] result,
    output logic cout
);

    assign {cout, result} = operand1 + operand2 + cin;
    
endmodule