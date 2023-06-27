//-----------------------------------------------------------------------------
// Title         : Testbench for the Instruction Memory
//-----------------------------------------------------------------------------
// File          : tb_ROM.sv
// Author        : David Ramón Alamán
// Created       : 17.09.2022
//-----------------------------------------------------------------------------

module tb_ROM();
    logic clk;
    logic [31:0] pc, instruction, expected_inst;
    logic[7:0] testIndex, errors;
    logic[63:0] testvector[25:0];

    // Device under test
    ROM dut(pc, instruction);

    // Generate clock
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // Initialization
    initial begin
        $display("Read Only Memory Testbench");
        $readmemh("vector_ROM.txt", testvector);
        testIndex = 0; errors = 0;
    end

    // Apply test vector
    always @(posedge clk) begin
        {pc, expected_inst} = testvector[testIndex];
    end

    // Check results
    always @(negedge clk) begin
        if(instruction !== expected_inst) begin
            $display("Error: instruction = %h (expecting %h).", instruction, expected_inst);
            errors = errors + 1;
        end

        testIndex = testIndex + 1;

        if(testvector[testIndex] === 64'bx) begin
            $display("%d tests completed with %d errors.", testIndex, errors);
            $stop;
        end
    end
endmodule