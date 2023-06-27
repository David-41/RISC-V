//-----------------------------------------------------------------------------
// Title         : Risc-V 32bit Integer Single Cycle
//-----------------------------------------------------------------------------
// File          : RV32I_SC.sv
// Author        : David Ramón Alamán
// Created       : 29.09.2022
//-----------------------------------------------------------------------------

module RV32I_SC #(
    parameter ROM_SIZE = 64,
    parameter RAM_DEPTH = 64,
    parameter WORD_SIZE = 32
)
(
    input logic clk, en, rst,
    input logic[WORD_SIZE - 1:0] ramOut,
    input logic[31:0] instruction,
    output logic RAMwe,
    output logic[$clog2(RAM_DEPTH)-1:0] RAMaddr,
    output logic[WORD_SIZE - 1:0] rs2,
    output logic[31:0] pc
);

    // Signal definition
    logic Regwe, branch, forceJump, ALUSrc2;
    logic[1:0] ALUOp, ALUSrc1, RegWriteSrc, PCSrc;
    logic[3:0] ALUCtrl, flags;
    logic[31:0] rd, rs1, ALUIn1, ALUIn2, ALUOut, immediate, pcAdded,
        pcImmediate, nextPC;

    assign RAMaddr = ALUOut[$clog2(RAM_DEPTH)+1 : $clog2(WORD_SIZE/8)];

    // Datapath modules instantiation
    RegisterFile RV_RegisterFile(
        .clk(clk),
        .we(Regwe), 
        .rst(rst),
        .reg1(instruction[19:15]),
        .reg2(instruction[24:20]),
        .reg3(instruction[11:7]),
        .dataIn(rd),
        .regData1(rs1),
        .regData2(rs2)
    );

    ALU RV_ALU (
        .operand1(ALUIn1),
        .operand2(ALUIn2),
        .control(ALUCtrl),
        .result(ALUOut),
        .flags(flags)
    );

    ImmediateGenerator RV_ImmGenerator(
        .instruction(instruction), 
        .immediate(immediate)
    );

    // Control modules instantiation
    Control RV_Control(
        .opCode(instruction[6:0]),
        .branch(branch),
        .forceJump(forceJump),
        .RAMwe(RAMwe),
        .Regwe(Regwe),
        .ALUSrc2(ALUSrc2),
        .ALUOp(ALUOp),
        .ALUSrc1(ALUSrc1),
        .RegWriteSrc(RegWriteSrc)
    );

    BranchLogic RV_BranchLogic(
        .branch(branch),
        .forceJump(forceJump),
        .opCode_3(instruction[3]),
        .funct3(instruction[14:12]),
        .flags(flags),
        .PCSrc(PCSrc)
    );

    ALUControl RV_ALUControl(
        .ALUOp(ALUOp),
        .func({instruction[14:12], instruction[30], instruction[5]}),
        .ALUCtrl(ALUCtrl)
    );

    // Adders and multiplexers
    Adder RV_PCAdder(
        .in1('d4),
        .in2(pc),
        .s(pcAdded)
    );

    Adder RV_PCImmediateAdder(
        .in1(pc),
        .in2(immediate),
        .s(pcImmediate)
    );

    mux3 RV_ALUSrcMux1(
        .data0(rs1),
        .data1('d0),
        .data2(pc),
        .s(ALUSrc1),
        .dout(ALUIn1)
    );

    mux3 RV_RdSrcMux(
        .data0(ramOut),
        .data1(ALUOut),
        .data2(pcAdded),
        .s(RegWriteSrc),
        .dout(rd)
    );

    mux3 RV_PCSrcMux(
        .data0(pcAdded),
        .data1(pcImmediate),
        .data2(ALUOut),
        .s(PCSrc),
        .dout(nextPC)
    );

    mux2 RV_ALUSrcMux2(
        .data1(immediate),
        .data2(rs2),
        .s(ALUSrc2),
        .dout(ALUIn2)
    );

    FlipFlop RV_PCFlipFlop(
        .clk(clk),
        .en(en),
		.rst(rst),
        .d(nextPC),
        .q(pc)
    );

endmodule