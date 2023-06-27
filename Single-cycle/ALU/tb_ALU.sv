//-----------------------------------------------------------------------------
// Title         : Testbench for the Arithmetic Logic Unit
//-----------------------------------------------------------------------------
// File          : tb_ALU.sv
// Author        : David Ramón Alamán
// Created       : 18.09.2022
//-----------------------------------------------------------------------------

module tb_ALU();
    logic[31:0] operand1, operand2, result, expected_result;
    logic[3:0] control;
    logic[3:0] flags, expected_flags;
    logic clk;
    logic[7:0] testIndex, errors;
    logic[103:0] testvector[25:0];

    // Device under test
    ALU dut(operand1, operand2, control, result, flags);

    // Generate clock
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end   

    // Initialization
    initial begin
        $display("Arithmetic Logic Unit Testbench");
        $readmemh("vector_ALU.txt", testvector);
        testIndex = 0; errors = 0;
    end

    // Apply test vector
    always @(posedge clk) begin
        {control, expected_flags, expected_result, operand2, operand1} = testvector[testIndex];
    end

    // Check results
    always @(negedge clk) begin
        if(expected_result !== result) begin
            $display("Error: result = %h (expecting %h).", result, expected_result);
            errors = errors + 1;
        end

        if(expected_flags !== flags) begin
            $display("Error: flags = %b (expecting %b).", flags, expected_flags);
            errors = errors + 1;
        end

        testIndex = testIndex + 1;

        if(testvector[testIndex] === 104'bx) begin
            $display("%d tests completed with %d errors.", testIndex, errors);
            $stop;
        end
    end
endmodule