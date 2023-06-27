//-----------------------------------------------------------------------------
// Title         : Testbench for the Control module
//-----------------------------------------------------------------------------
// File          : tb_Control.sv
// Author        : David Ramón Alamán
// Created       : 30.09.2022
//-----------------------------------------------------------------------------

module tb_Control();
    logic clk;
    logic[6:0] opCode;
    logic branch, forceJump, RAMwe, Regwe, ALUSrc2;
    logic expected_branch, expected_forceJump, expected_RAMwe, expected_Regwe, expected_ALUSrc2;
    logic[1:0] ALUOp, ALUSrc1, RegWriteSrc;
    logic[1:0] expected_ALUOp, expected_ALUSrc1, expected_RegWriteSrc;
    logic[7:0] testIndex;
    logic[15:0] errors;
    logic[17:0] testvector[20:0];

    // Device under test
    Control dut(opCode, branch, forceJump, RAMwe, Regwe, ALUSrc2, ALUOp, ALUSrc1, RegWriteSrc);

    // Generate clock
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // Initialization
    initial begin
        $display("Control Testbench");
        $readmemb("vector_Control.txt", testvector); // Load test vector
        testIndex = 0; errors = 0;
    end

    // Apply test vector
    always @(posedge clk) begin
        #1;
        {opCode, expected_branch, expected_forceJump, expected_RAMwe, expected_Regwe, expected_ALUSrc2, expected_ALUOp, expected_ALUSrc1, expected_RegWriteSrc} = testvector[testIndex];
    end

    // Check results
    always @(negedge clk) begin
        if(expected_branch !== branch) begin
            $display("Error: branch = %b (Expecting: %b)", branch, expected_branch);
            errors = errors + 1;
        end

        if(expected_forceJump !== forceJump) begin
            $display("Error: forceJump = %b (Expecting: %b)", forceJump, expected_forceJump);
            errors = errors + 1;
        end

        if(expected_RAMwe !== RAMwe) begin
            $display("Error: RAMwe = %b (Expecting: %b)", RAMwe, expected_RAMwe);
            errors = errors + 1;
        end

        if(expected_Regwe !== Regwe) begin
            $display("Error: Regwe = %b (Expecting: %b)", Regwe, expected_Regwe);
            errors = errors + 1;
        end

        if(expected_ALUSrc2 !== ALUSrc2) begin
            $display("Error: ALUSrc2 = %b (Expecting: %b)", ALUSrc2, expected_ALUSrc2);
            errors = errors + 1;
        end

        if(expected_ALUSrc1 !== ALUSrc1) begin
            $display("Error: ALUSrc1 = %b (Expecting: %b)", ALUSrc1, expected_ALUSrc1);
            errors = errors + 1;
        end

        if(expected_ALUOp !== ALUOp) begin
            $display("Error: ALUOp = %b (Expecting: %b)", ALUOp, expected_ALUOp);
            errors = errors + 1;
        end

        if(expected_RegWriteSrc !== RegWriteSrc) begin
            $display("Error: RegWriteSrc = %b (Expecting: %b)", RegWriteSrc, expected_RegWriteSrc);
            errors = errors + 1;
        end

        testIndex = testIndex + 1;

        if(testvector[testIndex] === 18'bx) begin
            $display("%d tests completed with %d errors.", testIndex, errors);
            $stop;
        end
    end
endmodule