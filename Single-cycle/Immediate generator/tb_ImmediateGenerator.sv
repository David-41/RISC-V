//-----------------------------------------------------------------------------
// Title         : Testbench for the Immediate Generator
//-----------------------------------------------------------------------------
// File          : tb_ImmediateGenerator.sv
// Author        : David Ramón Alamán
// Created       : 17.09.2022
//-----------------------------------------------------------------------------

module tb_ImmediateGenerator();

    logic clk;
    logic[31:0] instruction, immediate, expected_imm;
    logic[7:0] testIndex, errors;
    logic[63:0] testvector[25:0];

    // Device under test
    ImmediateGenerator dut(instruction, immediate);

    // Generate clock
    always begin
        clk = 1; #5; 
        clk = 0; #5;
    end

    // Initialization
    initial begin
        $display("Immediate Generator Testbench");
        $readmemh("vector_ImmediateGenerator.txt", testvector); // Load test vector
        testIndex = 0; errors = 0;
    end

    // Apply test vector
    always @(posedge clk) begin
        {instruction, expected_imm} = testvector[testIndex];
    end

    // Check results
    always @(negedge clk) begin
        if(immediate !== expected_imm) begin
            $display("Error: instruction = %h (Op = %d)", instruction, instruction[6:0]);
            $display(" inmmediate obtained = %h (expecting %h)", immediate, expected_imm);
            errors = errors + 1;
        end

        testIndex = testIndex + 1;

        if(testvector[testIndex] === 64'bx) begin
            $display("%d tests completed with %d errors.", testIndex, errors);
            $stop;
        end
    end

endmodule