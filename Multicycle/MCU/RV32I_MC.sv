//--------------------------------------------------------------
// Title         : RV32I - Mulcicycle implementation - MCU
//--------------------------------------------------------------
// File          : RV32I_MC.sv
// Author        : David Ramon Alaman
// Created       : 25.12.2022
//--------------------------------------------------------------

module RV32I_MC #(
	parameter DEPTH = 64,
    parameter PROGRAM_FILE = "memotest.hex"
)(
    input logic clk, rst, en,
    output logic[1:0] pwm1out, pwm2out,
    output logic[6:0] hex0, hex1, hex2, hex3, hex4, hex5
);

    // Signals definition
    logic memWE, InstructionRead, DataRegEN,
        cs_RAM, cs_PID1, cs_PID2, cs_ADC, cs_TIM, cs_H7S, cs_PTL;
    logic[2:0] read_mux_src;
    logic[31:0] memOut, memAddr, memIn, instruction, pcOut,
        RAMOut, PID1Out, PID2Out, ADCOut, TIMOut, H7SOut, PTLOut, ADCChannel0,
        ADCChannel1, pid_in, timOut1, timOut2, nc;

    // Device under test
    RV32I_Multicycle RISCV(
        .clk(clk),
        .arst(rst),
        .en(en),
        .data(memOut),
        .instruction(instruction),
        .memWE(memWE),
        .InstructionRead(InstructionRead),
        .DataRegEN(DataRegEN),
        .memAddr(memAddr),
        .memIn(memIn),
        .pcOut(pcOut)
    );

    MemoryController RV_MemoryController (
        .read(DataRegEN),
        .write(memWE),
        .addr(memAddr),
        .cs_RAM(cs_RAM),
        .cs_PID1(cs_PID1),
        .cs_PID2(cs_PID2),
        .cs_ADC(cs_ADC),
        .cs_TIM(cs_TIM),
        .cs_H7S(cs_H7S),
        .cs_PTL(cs_PTL),
        .read_mux(read_mux_src)
    );

    mux7 RV_ReadMux (
        .data0(RAMOut),
        .data1(PID1Out), 
        .data2(PID2Out),
        .data3(ADCOut),
        .data4(TIMOut),
        .data5(H7SOut),
        .data6(PTLOut),
        .s(read_mux_src),
        .dout(memOut)
    );

    Memory #(
        .DEPTH(DEPTH),
        .WORD_SIZE(32),
        .INITIALIZE(1),
        .FILE(PROGRAM_FILE)
    ) RV_ROM (
        .clk(clk),
        .we(1'b0),
        .read(InstructionRead),
        .cs(1'b1),
        .addr(pcOut[$clog2(DEPTH)+1:2]),
        .dataIn(0),
        .dataOut(instruction)
    );

    Memory #(
        .DEPTH(DEPTH),
        .WORD_SIZE(32),
        .INITIALIZE(0),
        .FILE("")
    ) RV_RAM (
        .clk(clk),
        .we(memWE),
        .read(DataRegEN),
        .cs(cs_RAM),
        .addr(memAddr[$clog2(DEPTH)+1:2]),
        .dataIn(memIn),
        .dataOut(RAMOut)
    );

    PID_Reg #(
        .PRESCALER_DEFAULT_VALUE(50000)
    ) RV_pid1 (
        .clk(clk), 
        .chipSelect(cs_PID1), 
        .write(memWE), 
        .read(DataRegEN), 
        .rst(rst),
        .en(en),
        .addr(memAddr[5:2]),
        .writeData(memIn), 
        .feedback_bypass(ADCChannel0),
        .readData(PID1Out),
        .control_bypass(pid_in)
    );

    PID_Reg #(
        .PRESCALER_DEFAULT_VALUE(50000)
    ) RV_pid2 (
        .clk(clk), 
        .chipSelect(cs_PID2), 
        .write(memWE), 
        .read(DataRegEN), 
        .rst(rst),
        .en(en),
        .addr(memAddr[5:2]),
        .writeData(memIn), 
        .feedback_bypass(ADCChannel1),
        .readData(PID2Out),
        .control_bypass(nc)
    );

    ADC_reg RV_ADC(
        .clk(clk), 
        .chipSelect(cs_ADC), 
        .read(DataRegEN), 
        .rst(rst), 
        .en(en),
        .addr(memAddr[2]), 
        .channel0(ADCChannel0), 
        .channel1(ADCChannel1), 
        .readData(ADCOut)
    );

    Timer #(
        .PRESCALER_DEFAULT_VALUE(1)
    ) RV_Timer (
        .clk(clk), 
        .chipSelect(cs_TIM), 
        .write(memWE), 
        .read(DataRegEN), 
        .rst(rst), 
        .en(en),
        .addr(memAddr[5:2]),
        .writeData(memIn),
        .bypass1(timOut1),
        .bypass2(timOut2),
        .pwm1out(pwm1out), 
        .pwm2out(pwm2out),
        .readData(TIMOut)
    );

    Hex7Segments RV_Hex7Segments(
        .clk(clk), 
        .chipSelect(cs_H7S), 
        .write(memWE),
        .read(DataRegEN),
        .writeData(memIn),
        .hex5(hex5), 
        .hex4(hex4), 
        .hex3(hex3), 
        .hex2(hex2), 
        .hex1(hex1), 
        .hex0(hex0),
        .readData(H7SOut)
    );

    PID_TIM_Link RV_PIDTIMLink(
        .clk(clk),
        .chipSelect(cs_PTL),
        .write(memWE),
        .read(DataRegEN),
        .rst(rst),
        .en(en),
        .pid_in(pid_in),
        .writeData(memIn),
        .timOut1(timOut1),
        .timOut2(timOut2),
        .readData(PTLOut)
    );
    
endmodule