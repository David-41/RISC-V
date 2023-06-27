//-----------------------------------------------------------------------------
// Title         : Zero extender for SLT, SLTI, SLTU and SLTU instructions
//-----------------------------------------------------------------------------
// File          : zeroExtender.sv
// Author        : David Ramón Alamán
// Created       : 19.09.2022
//-----------------------------------------------------------------------------


module zeroExtender (
    input logic inbit,
    output logic[31:0] extended
);

    assign extended = {31'b0, inbit};

endmodule