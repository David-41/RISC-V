//-----------------------------------------------------------------------------
// Title         : Instruction Memory
//-----------------------------------------------------------------------------
// File          : ROM.sv
// Author        : David Ramón Alamán
// Created       : 17.09.2022
//-----------------------------------------------------------------------------

module ROM #(
    parameter DEPTH = 1024
)
(
    input logic[31:0] pc,
    output logic[31:0] instruction
);

    logic[31:0] memory[DEPTH-1:0];

    initial begin
        $readmemh("test_instructions.txt", memory);
    end

    assign instruction = memory[pc[$clog2(DEPTH)+1:2]];
    
endmodule