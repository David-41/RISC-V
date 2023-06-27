//-----------------------------------------------------------------------------
// Title         : Testbench for the Data Memory
//-----------------------------------------------------------------------------
// File          : tb_RAM.sv
// Author        : David Ramón Alamán
// Created       : 22.09.2022
//-----------------------------------------------------------------------------

module tb_RAM();
    logic clk, we, testEN;
    logic [31:0] dataIn, dataOut, expected_dataOut;
    logic [$clog2(1024)-1:0] addr;
    logic[7:0] testIndex, errors;
    logic[96:0] testvector[25:0];

    // Device under test
    RAM dut(clk, we, addr, dataIn, dataOut);

    // Generate clock
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // Initialization
    initial begin
        $display("Random Access Memory Testbench");
        $readmemh("vector_RAM.txt", testvector);
        testIndex = 0; errors = 0;
        testEN = 1; #7; testEN = 0;
    end

    // Apply test vector
    always @(posedge clk) begin
        {we, addr, dataIn, expected_dataOut} = testvector[testIndex];
    end

    // Check results
    always @(negedge clk) begin
        if(~testEN) begin
            if(dataOut !== expected_dataOut) begin
                $display("Error: Data = %h (expecting %h).", dataOut, expected_dataOut);
                errors = errors + 1;
            end

            testIndex = testIndex + 1;

            if(testvector[testIndex] === 97'bx) begin
                $display("%d tests completed with %d errors.", testIndex, errors);
                $stop;
            end
        end
    end
endmodule