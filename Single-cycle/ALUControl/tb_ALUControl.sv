//-----------------------------------------------------------------------------
// Title         : Testbench for the ALU Controller
//-----------------------------------------------------------------------------
// File          : tb_ALUControl.sv
// Author        : David Ramón Alamán
// Created       : 27.09.2022
//-----------------------------------------------------------------------------

module tb_ALUControl();
    logic clk;
    logic [1:0] ALUOp;
    logic [4:0] func;
    logic [3:0] ALUCtrl, expected_ALUCtrl;
    logic[7:0] testIndex, errors;
    logic[10:0] testvector[200:0];

    // Device under test
    ALUControl dut(ALUOp, func, ALUCtrl);

    // Generate Clock
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // Initialization
    initial begin
        $display("ALU Control Testbench");
        $readmemb("vector_ALUControl.txt", testvector);
        testIndex = 0; errors = 0;
    end

    // Applay test vectors;
    always @(posedge clk) begin
        #1; 
        {ALUOp, func, expected_ALUCtrl} = testvector[testIndex];
    end

    // Check results
    always @(negedge clk) begin
        if(ALUCtrl !== expected_ALUCtrl) begin
            $display("Error: ALUCtrl = %h (expecting %h).", ALUCtrl, expected_ALUCtrl);
            errors = errors + 1;
        end

        testIndex = testIndex + 1;

        if(testvector[testIndex] === 11'bx) begin
            $display("%d tests completed with %d errors.", testIndex, errors);
            $stop;
        end
    end
endmodule