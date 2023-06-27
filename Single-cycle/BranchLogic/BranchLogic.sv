//-----------------------------------------------------------------------------
// Title         : Branch Logic
//-----------------------------------------------------------------------------
// File          : BranchLogic.sv
// Author        : David Ramón Alamán
// Created       : 27.09.2022
//-----------------------------------------------------------------------------

module BranchLogic(
    input logic branch, forceJump, opCode_3,
    input logic[2:0] funct3,
    input logic[3:0] flags,
    output logic[1:0] PCSrc
);

    always_comb begin
        if(forceJump) begin
            if(opCode_3) PCSrc = 2'b01;
            else PCSrc = 2'b10;
        end

        else if(branch) begin
            PCSrc[1] = 0; 
            case (funct3)
                3'b000: PCSrc[0] = flags[0]; // beq
                3'b001: PCSrc[0] = ~flags[0]; // bne
                3'b100: PCSrc[0] = flags[1] ^ flags[3]; // blt
                3'b101: PCSrc[0] = ~(flags[1] ^ flags[3]); // bge
                3'b110: PCSrc[0] = ~flags[2]; // bltu
                3'b111: PCSrc[0] = flags[2]; // bgeu
                default: PCSrc[0] = 0;
            endcase
        end

        else PCSrc = 2'b0;
    end
endmodule