//-----------------------------------------------------------------------------
// Title         : Testbench for the Register File
//-----------------------------------------------------------------------------
// File          : tb_RegisterFile.sv
// Author        : David Ramón Alamán
// Created       : 17.09.2022
//-----------------------------------------------------------------------------

module tb_RegisterFile();
    logic clk, we, rst, testEN;
    logic[4:0] reg1, reg2, reg3;
    logic[31:0] dataIn, regData1, regData2;
    logic[31:0] expected_regData1, expected_regData2;
    logic[7:0] testIndex, errors;
    logic[36:0] testvector1[25:0];
    logic[36:0] testvector2[25:0];
    logic[37:0] testvector3[25:0];

    // Device under test
    RegisterFile dut(clk, we, rst, reg1, reg2, reg3, dataIn, regData1, regData2);

    // Generate Clock
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // Initialization
    initial begin
        $display("Register File Testbench");
        $readmemh("vector_RF1.txt", testvector1);
        $readmemh("vector_RF2.txt", testvector2);
        $readmemh("vector_RF3.txt", testvector3);
        testIndex = 0; errors = 0;
        testEN = 1; rst = 0; #7; testEN = 0; rst = 1;
        #60; rst = 0;
    end

    // Applay test vectors;
    always @(posedge clk) begin
        #1; 
        {reg1, expected_regData1} = testvector1[testIndex];
        {reg2, expected_regData2} = testvector2[testIndex];
        {we, reg3, dataIn} = testvector3[testIndex];
    end

    // Check results
    always @(negedge clk) begin
        if(~testEN) begin
            if(regData1 !== expected_regData1) begin
                $display("Error in Register 1 (expecting %h).", expected_regData1);
                errors = errors + 1;
            end

            if(regData2 !== expected_regData2) begin
                $display("Error in Register 2 (expecting %h).", expected_regData2);
                errors = errors + 1;
            end

            testIndex = testIndex + 1;

            if(testvector1[testIndex] === 37'bx) begin
                $display("%d tests completed with %d errors.", testIndex, errors);
                $stop;
            end
        end
    end
endmodule