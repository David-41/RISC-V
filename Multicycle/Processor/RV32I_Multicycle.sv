//-----------------------------------------------------------------------------
// Title         : Risc-V 32bit Integer - Mulcicycle implementation - MPU
//-----------------------------------------------------------------------------
// File          : RV32I_Multicycle.sv
// Author        : David Ramón Alamán
// Created       : 21.10.2022
//-----------------------------------------------------------------------------

module RV32I_Multicycle(
    input logic clk, arst, en,
    input logic[31:0] data, instruction,
    output memWE, InstructionRead, DataRegEN,
    output[31:0] memAddr, memIn, pcOut
);
    // Signal definition
    logic RegWE, PCRegEN, FetchRegEN, RFRegEN, ALUOutRegEN, PCRegRST, 
        FetchRegRST, RFRegRST, ALUOutRegRST, branch;
    logic[1:0] ALUIn1Src, ALUIn2Src, ResultSrc, ALUOp;
    logic[3:0] ALUCtrl, flags;
    logic[31:0] rs1, rs2, ALUIn1, ALUIn2, ALUOut, 
        pc, pcOld, rs1Reg, rs2Reg, ALUOutReg, result, immediate;

    assign memIn = rs2Reg;
    assign pcOut = pc;
    //assign memAddr = result;
    assign memAddr = ALUOutReg;

    // Datapath modules instantiation
    RegisterFile RV_Registerfile(
        .clk(clk),
        .we(RegWE),
        .rst(arst),
        .reg1(instruction[19:15]),
        .reg2(instruction[24:20]),
        .reg3(instruction[11:7]),
        .dataIn(result),
        .regData1(rs1),
        .regData2(rs2)
    );

    ALU RV_ALU(
        .operand1(ALUIn1),
        .operand2(ALUIn2),
        .control(ALUCtrl),
        .result(ALUOut),
        .flags(flags)
    );

    ImmediateGenerator RV_ImmediateGenerator(
        .instruction(instruction),
        .immediate(immediate)
    );

    // Control modules instantiation
    Control RV_Control(
        .clk(clk),
        .arst(arst),
        .en(en),
        .branch(branch),
        .opCode(instruction[6:0]),
        .PCRegEN(PCRegEN),
        .FetchRegEN(FetchRegEN), 
        .RFRegEN(RFRegEN), 
        .ALUOutRegEN(ALUOutRegEN),
        .DataRegEN(DataRegEN), 
        .PCRegRST(PCRegRST), 
        .FetchRegRST(FetchRegRST), 
        .RFRegRST(RFRegRST),
        .ALUOutRegRST(ALUOutRegRST),
        .InstructionRead(InstructionRead),
        .ALUIn1Src(ALUIn1Src), 
        .ALUIn2Src(ALUIn2Src), 
        .ResultSrc(ResultSrc), 
        .memWE(memWE), 
        .Regwe(RegWE),
        .ALUOp(ALUOp)
    );
    
    ALUControl RV_ALUControl(
        .ALUOp(ALUOp),
        .func({instruction[14:12], instruction[30], instruction[5]}),
        .ALUCtrl(ALUCtrl)
    );

    BranchLogic RV_BranchLogic(
        .funct3(instruction[14:12]),
        .flags(flags),
        .branch(branch)
    );

    // Multiplexers

    mux4 ALUIn1Mux(
        .data0(rs1Reg),
        .data1(32'b0),
        .data2(pcOld),
        .data3(pc),
        .s(ALUIn1Src),
        .dout(ALUIn1)
    );

    mux3 ALUIn2Mux(
        .data0(immediate),
        .data1(rs2Reg),
        .data2(32'd4),
        .s(ALUIn2Src),
        .dout(ALUIn2)
    );

    mux3 ResultMux(
        .data0(ALUOutReg),
        .data1(ALUOut),
        .data2(data),
        .s(ResultSrc),
        .dout(result)
    );

    // Registers

    FlipFlop PCReg(
        .clk(clk),
        .en(PCRegEN),
        .srst(PCRegRST),
        .arst(arst),
        .d(result),
        .q(pc)
    );

    FlipFlop FetchReg(
        .clk(clk),
        .en(FetchRegEN),
        .srst(FetchRegRST),
        .arst(arst),
        .d(pc),
        .q(pcOld)
    );

    FlipFlop2 RFReg(
        .clk(clk),
        .en(RFRegEN),
        .srst(RFRegRST),
        .arst(arst),
        .d0(rs1),
        .d1(rs2),
        .q0(rs1Reg),
        .q1(rs2Reg)
    );

    FlipFlop ALUReg(
        .clk(clk),
        .en(ALUOutRegEN),
        .srst(ALUOutRegRST),
        .arst(arst),
        .d(ALUOut),
        .q(ALUOutReg)
    );

endmodule