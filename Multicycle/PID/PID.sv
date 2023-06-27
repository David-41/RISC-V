//--------------------------------------------------------------
// Title         : PID Controller
//--------------------------------------------------------------
// File          : PID.sv
// Author        : David Ramon Alaman
// Created       : 06.12.2022
//--------------------------------------------------------------

module PID (
    input clk, en, arst, srst,
    input logic[31:0] reference, feedback, k1, k2, k3,
    output logic[31:0] control
);

    logic[31:0] error, error1, error2, control1, feedback_d;
    logic[63:0] multiplied1, multiplied2, multiplied3;

    assign error = reference - feedback_d;
    assign control = multiplied1[31:0] + multiplied2[31:0] + multiplied3[31:0] + control1;

    FlipFlop delay1(
        .clk(clk),
        .en(en),
        .srst(srst),
        .arst(arst),
        .d(error),
        .q(error1)
    );

    FlipFlop delay2(
        .clk(clk),
        .en(en),
        .srst(srst),
        .arst(arst),
        .d(error1),
        .q(error2)
    );

    FlipFlop delayCtrl(
        .clk(clk),
        .en(en),
        .srst(srst),
        .arst(arst),
        .d(control),
        .q(control1)
    );

    FlipFlop feedback_ff(
        .clk(clk),
        .en(en),
        .srst(srst),
        .arst(arst),
        .d(feedback),
        .q(feedback_d)
    );

    Multiplier_test mult_1(
        .dataa(k1),
        .datab(error),
        .result(multiplied1)
    );

    Multiplier_test mult_2(
        .dataa(k2),
        .datab(error1),
        .result(multiplied2)
    );

    Multiplier_test mult_3(
        .dataa(k3),
        .datab(error2),
        .result(multiplied3)
    );
    
endmodule