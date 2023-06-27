//-----------------------------------------------------------------------------
// Title         : Arithmetic Logic Unit
//-----------------------------------------------------------------------------
// File          : ALU.sv
// Author        : David Ramón Alamán
// Created       : 18.09.2022
//-----------------------------------------------------------------------------

module ALU(
    input logic[31:0] operand1, operand2,
    input logic[3:0] control,
    output logic[31:0] result,
    output logic[3:0] flags
);

    logic[31:0] muxedOperand2, sum, ored, anded, xored, slt, sll, srl, sra, sltu;
    logic cout, sltnonext, sltunonext;

    // Allows to use only one full adder
    mux2 substractionmux(operand2, ~operand2, control[0], muxedOperand2);

    // Addition and substraction adder
    fullAdder adder(operand1, muxedOperand2, control[0], sum, cout);
    
    // OR, AND and XOR operations
    assign ored = operand1 | operand2;
    assign anded = operand1 & operand2;
    assign xored = operand1 ^ operand2;

    //SLL, SRL and SRA operations;
    assign sll = operand1 << operand2[4:0];
    assign srl = operand1 >> operand2[4:0];
    assign sra = $signed(operand1) >>> operand2[4:0];

    // SLT implementation
    assign sltnonext = sum[31] ^ flags[3];
    zeroExtender zero(sltnonext, slt);

    // SLTU implementation
    assign sltunonext = ~flags[2];
    zeroExtender zero_u(sltunonext, sltu);

    // Flags
    // Flags = {Overflow, Carry, Negative, Zero}

    assign flags[0] = &(~result);
    assign flags[1] = result[31];
    assign flags[2] = cout & ~control[1];
    assign flags[3] = ~(control[0] ^ operand1[31] ^ operand2[31]) &
        (operand1[31] ^ sum[31]) & ~control[1];

    // Result
	mux10 resultmux('{sltu, sra, srl, sll, slt, xored, ored, anded, sum, sum}, control, result);
    
endmodule