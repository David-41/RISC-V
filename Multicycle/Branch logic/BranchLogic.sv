//-----------------------------------------------------------------------------
// Title         : Branch Logic
//-----------------------------------------------------------------------------
// File          : BranchLogic.sv
// Author        : David Ramón Alamán
// Created       : 27.09.2022
//-----------------------------------------------------------------------------

module BranchLogic(
    input logic[2:0] funct3,
    input logic[3:0] flags,
    output logic branch
);

    always_comb begin
        case (funct3)
            3'b000: branch = flags[0]; // beq
            3'b001: branch = ~flags[0]; // bne
            3'b100: branch = flags[1] ^ flags[3]; // blt
            3'b101: branch = ~(flags[1] ^ flags[3]); // bge
            3'b110: branch = ~flags[2]; // bltu
            3'b111: branch = flags[2]; // bgeu
            default: branch = 0;
        endcase
    end
endmodule