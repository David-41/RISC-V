//-----------------------------------------------------------------------------
// Title         : Arithmetic Logic Unit Controller
//-----------------------------------------------------------------------------
// File          : ALUControl.sv
// Author        : David Ramón Alamán
// Created       : 27.09.2022
//-----------------------------------------------------------------------------


module ALUControl(
    input logic[1:0] ALUOp,
    input logic[4:0] func, // {Funct3, Funct7_5, OP_5}
    output logic[3:0] ALUCtrl
);

    always_comb begin
        case (ALUOp)
            2'b00: begin
                casez (func[4:1])
                    4'b000?: begin
                        if(func[0] === 1) begin
                            if(func[1] === 0) ALUCtrl = 4'd0; // add
                            else ALUCtrl = 4'd1; // sub
                        end
                        else ALUCtrl = 4'd0; // addi
                    end                            
                    4'b0010: ALUCtrl = 4'd6; // sll, slli
                    4'b010?: ALUCtrl = 4'd5; // slt, slti
                    4'b011?: ALUCtrl = 4'd9; // sltu, sltiu
                    4'b100?: ALUCtrl = 4'd4; // xor, xori
                    4'b1010: ALUCtrl = 4'd7; // srl, srli
                    4'b1011: ALUCtrl = 4'd8; // sra, srai
                    4'b110?: ALUCtrl = 4'd3; // or, ori
                    4'b111?: ALUCtrl = 4'd2; // and, andi
                    default: ALUCtrl = 4'bx;
                endcase
                end
            2'b01: ALUCtrl = 4'd1;
            2'b10: ALUCtrl = 4'd0;
            default: ALUCtrl = 4'bx;
        endcase
    end 
endmodule