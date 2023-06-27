//-----------------------------------------------------------------------------
// Title         : Control module
//-----------------------------------------------------------------------------
// File          : Control.sv
// Author        : David Ramón Alamán
// Created       : 30.09.2022
//-----------------------------------------------------------------------------

module Control(
    input logic[6:0] opCode,
    output logic branch, forceJump, RAMwe, Regwe, ALUSrc2,
    output logic[1:0] ALUOp, ALUSrc1, RegWriteSrc
);

    always_comb begin
        case (opCode)
            7'd3: begin
                branch =      1'b0;
                forceJump =   1'b0;
                RAMwe =       1'b0;
                Regwe =       1'b1;
                ALUSrc2 =     1'b0;
                ALUOp =       2'b10;
                ALUSrc1 =     2'b00;
                RegWriteSrc = 2'b00;
            end 
            7'd19: begin
                branch =      1'b0;
                forceJump =   1'b0;
                RAMwe =       1'b0;
                Regwe =       1'b1;
                ALUSrc2 =     1'b0;
                ALUOp =       2'b00;
                ALUSrc1 =     2'b00;
                RegWriteSrc = 2'b01;
            end 
            7'd23: begin
                branch =      1'b0;
                forceJump =   1'b0;
                RAMwe =       1'b0;
                Regwe =       1'b1;
                ALUSrc2 =     1'b0;
                ALUOp =       2'b10;
                ALUSrc1 =     2'b10;
                RegWriteSrc = 2'b01;
            end 
            7'd35: begin
                branch =      1'b0;
                forceJump =   1'b0;
                RAMwe =       1'b1;
                Regwe =       1'b0;
                ALUSrc2 =     1'b0;
                ALUOp =       2'b10;
                ALUSrc1 =     2'b00;
                RegWriteSrc = 2'b01;
            end 
            7'd51: begin
                branch =      1'b0;
                forceJump =   1'b0;
                RAMwe =       1'b0;
                Regwe =       1'b1;
                ALUSrc2 =     1'b1;
                ALUOp =       2'b00;
                ALUSrc1 =     2'b00;
                RegWriteSrc = 2'b01;
            end 
            7'd55: begin
                branch =      1'b0;
                forceJump =   1'b0;
                RAMwe =       1'b0;
                Regwe =       1'b1;
                ALUSrc2 =     1'b0;
                ALUOp =       2'b10;
                ALUSrc1 =     2'b01;
                RegWriteSrc = 2'b01;
            end 
            7'd99: begin
                branch =      1'b1;
                forceJump =   1'b0;
                RAMwe =       1'b0;
                Regwe =       1'b0;
                ALUSrc2 =     1'b1;
                ALUOp =       2'b01;
                ALUSrc1 =     2'b00;
                RegWriteSrc = 2'b01;
            end 
            7'd103: begin
                branch =      1'b0;
                forceJump =   1'b1;
                RAMwe =       1'b0;
                Regwe =       1'b1;
                ALUSrc2 =     1'b0;
                ALUOp =       2'b10;
                ALUSrc1 =     2'b00;
                RegWriteSrc = 2'b10;
            end 
            7'd111: begin
                branch =      1'b0;
                forceJump =   1'b1;
                RAMwe =       1'b0;
                Regwe =       1'b1;
                ALUSrc2 =     1'b0;
                ALUOp =       2'b10;
                ALUSrc1 =     2'b00;
                RegWriteSrc = 2'b10;
            end 
            default: begin
                branch =      1'bx;
                forceJump =   1'bx;
                RAMwe =       1'bx;
                Regwe =       1'bx;
                ALUSrc2 =     1'bx;
                ALUOp =       2'bx;
                ALUSrc1 =     2'bx;
                RegWriteSrc = 2'bx;
            end 
        endcase
    end 
endmodule