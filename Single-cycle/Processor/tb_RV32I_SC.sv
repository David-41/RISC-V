//-----------------------------------------------------------------------------
// Title         : RISCV-32I testbench
//-----------------------------------------------------------------------------
// File          : tb_RV32I_SC.sv
// Author        : David Ramón Alamán
// Created       : 04.10.2022
//-----------------------------------------------------------------------------

module tb_RV32I_SC #(
    parameter ROM_SIZE = 64,
    parameter RAM_DEPTH = 64,
    parameter WORD_SIZE = 32
)();

    logic clk, en, rst;
    logic[WORD_SIZE - 1:0] ramOut;
    logic[31:0] instruction;
    logic RAMwe;
    logic[$clog2(RAM_DEPTH)-1:0] RAMaddr;
    logic[WORD_SIZE - 1:0] rs2;
    logic[31:0] pc;

    // Device under test
    RV32I_SC #(ROM_SIZE, RAM_DEPTH, WORD_SIZE) RiscV(
        .clk(clk),
        .en(en),
        .rst(rst),
        .ramOut(ramOut),
        .instruction(instruction),
        .RAMwe(RAMwe),
        .RAMaddr(RAMaddr),
        .rs2(rs2),
        .pc(pc)
    );

    RAM #(RAM_DEPTH, WORD_SIZE) RV_RAM(
        .clk(clk),
        .we(RAMwe),
        .addr(RAMaddr),
        .dataIn(rs2),
        .dataOut(ramOut)
    );

    ROM #(ROM_SIZE) RV_ROM(
        .pc(pc),
        .instruction(instruction)
    );

    // Generate clock
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // Initialization
    initial begin
        //$readmemh("vector_ALU.txt", testvector);
        //testIndex = 0; errors = 0;
        en = 0;
        rst = 0; #7 rst = 1;
        en = 1;
    end
    
endmodule

module ROM #(
    parameter DEPTH = 1024
)
(
    input logic[31:0] pc,
    output logic[31:0] instruction
);

    logic[31:0] memory[DEPTH-1:0];

    initial begin
        $readmemh("bubblesort.hex", memory);
    end

    assign instruction = memory[pc[$clog2(DEPTH)+1:2]];
    
endmodule

module RAM #(
    parameter DEPTH = 1024,
    parameter WORD_SIZE = 32
)(
    input logic clk, we,
    input logic[$clog2(DEPTH)-1:0] addr, 
    input logic[WORD_SIZE-1:0] dataIn,
    output logic[WORD_SIZE-1:0] dataOut
);
    logic[WORD_SIZE-1:0] ram[DEPTH-1:0];

    assign dataOut = ram[addr];

    always @(posedge clk) begin
        if(we) begin
            ram[addr] <= dataIn;
        end
    end
    
endmodule