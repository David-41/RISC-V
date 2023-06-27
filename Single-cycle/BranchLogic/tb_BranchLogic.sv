//-----------------------------------------------------------------------------
// Title         : Testbench for the Branch Logic
//-----------------------------------------------------------------------------
// File          : tb_BranchLogic.sv
// Author        : David Ramón Alamán
// Created       : 27.09.2022
//-----------------------------------------------------------------------------

module tb_BranchLogic();

    logic clk, branch, forceJump, opCode_3;
    logic[1:0] PCSrc, expected_PCSrc;
    logic[2:0] funct3;
    logic[3:0] flags;
    logic[7:0] testIndex, errors;
    logic[11:0] testvector[33:0];

    // Device under test
    BranchLogic dut(branch, forceJump, opCode_3, funct3, flags, PCSrc);

    // Generate clock
    always begin
        clk = 1; #5; 
        clk = 0; #5;
    end

    // Initialization
    initial begin
        $display("Branch Logic Testbench");
        $readmemb("vector_BranchLogic.txt", testvector); // Load test vector
        testIndex = 0; errors = 0;
    end

    // Apply test vector
    always @(posedge clk) begin
        #1;
        {forceJump, branch, funct3, flags, opCode_3, expected_PCSrc} = testvector[testIndex];
    end

    // Check results
    always @(negedge clk) begin
        if(PCSrc !== expected_PCSrc) begin
            $display("Error: PCSrc = %b (Expected = %b)", PCSrc, expected_PCSrc);
            errors = errors + 1;
        end

        testIndex = testIndex + 1;

        if(testvector[testIndex] ===12'bx) begin
            $display("%d tests completed with %d errors.", testIndex, errors);
            $stop;
        end
    end

endmodule