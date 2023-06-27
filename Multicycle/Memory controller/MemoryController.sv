//--------------------------------------------------------------
// Title         : Memory Controller
//--------------------------------------------------------------
// File          : MemoryController.sv
// Author        : David Ramon Alaman
// Created       : 31.10.2022
//--------------------------------------------------------------

module MemoryController #(
    parameter RAM_ADDR = 32'h1000_0000,
    parameter PID1_ADDR = 32'hC000_0000,
    parameter PID2_ADDR = 32'hC000_0040,
    parameter ADC_ADDR = 32'hC000_0078,
    parameter TIM_ADDR = 32'hC000_0080,
    parameter H7S_ADDR = 32'hC000_00A8,
    parameter PTL_ADDR = 32'hC000_00AC
)(
    input logic read, write,
    input logic[31:0] addr, 
    output logic cs_RAM, cs_PID1, cs_PID2, cs_ADC, cs_TIM, cs_H7S, cs_PTL,
    output logic[2:0] read_mux 
);

    always_comb begin 
        if((addr >= RAM_ADDR) && (addr < PID1_ADDR) && (read || write)) begin
            cs_RAM = 1'b1;
            cs_PID1 = 1'b0;
            cs_PID2 = 1'b0;
            cs_ADC = 1'b0;
            cs_TIM = 1'b0;
            cs_H7S = 1'b0;
            cs_PTL = 1'b0;
        end
        else if ((addr >= PID1_ADDR) && (addr < PID2_ADDR) && (read || write)) begin
            cs_RAM = 1'b0;
            cs_PID1 = 1'b1;
            cs_PID2 = 1'b0;
            cs_ADC = 1'b0;
            cs_TIM = 1'b0;
            cs_H7S = 1'b0;
            cs_PTL = 1'b0;
        end
        else if ((addr >= PID2_ADDR) && (addr < ADC_ADDR) && (read || write)) begin
            cs_RAM = 1'b0;
            cs_PID1 = 1'b0;
            cs_PID2 = 1'b1;
            cs_ADC = 1'b0;
            cs_TIM = 1'b0;
            cs_H7S = 1'b0;
            cs_PTL = 1'b0;
        end
        else if ((addr >= ADC_ADDR) && (addr < TIM_ADDR) && (read || write)) begin
            cs_RAM = 1'b0;
            cs_PID1 = 1'b0;
            cs_PID2 = 1'b0;
            cs_ADC = 1'b1;
            cs_TIM = 1'b0;
            cs_H7S = 1'b0;
            cs_PTL = 1'b0;
        end
        else if ((addr >= TIM_ADDR) && (addr < H7S_ADDR) && (read || write)) begin
            cs_RAM = 1'b0;
            cs_PID1 = 1'b0;
            cs_PID2 = 1'b0;
            cs_ADC = 1'b0;
            cs_TIM = 1'b1;
            cs_H7S = 1'b0;
            cs_PTL = 1'b0;
        end
        else if (addr == H7S_ADDR && (read || write)) begin
            cs_RAM = 1'b0;
            cs_PID1 = 1'b0;
            cs_PID2 = 1'b0;
            cs_ADC = 1'b0;
            cs_TIM = 1'b0;
            cs_H7S = 1'b1;
            cs_PTL = 1'b0;
        end
        else if (addr == PTL_ADDR && (read || write)) begin
            cs_RAM = 1'b0;
            cs_PID1 = 1'b0;
            cs_PID2 = 1'b0;
            cs_ADC = 1'b0;
            cs_TIM = 1'b0;
            cs_H7S = 1'b0;
            cs_PTL = 1'b1;
        end
        else begin
            cs_RAM = 1'b0;
            cs_PID1 = 1'b0;
            cs_PID2 = 1'b0;
            cs_ADC = 1'b0;
            cs_TIM = 1'b0;
            cs_H7S = 1'b0;
            cs_PTL = 1'b0;
        end
    end

    always_comb begin 
        if((addr >= RAM_ADDR) && (addr < PID1_ADDR)) begin
            read_mux = 3'b000;
        end
        else if ((addr >= PID1_ADDR) && (addr < PID2_ADDR)) begin
            read_mux = 3'b001;
        end
        else if ((addr >= PID2_ADDR) && (addr < ADC_ADDR)) begin
            read_mux = 3'b010;
        end
        else if ((addr >= ADC_ADDR) && (addr < TIM_ADDR)) begin
            read_mux = 3'b011;
        end
        else if ((addr >= TIM_ADDR) && (addr < H7S_ADDR)) begin
            read_mux = 3'b100;
        end
        else if (addr == H7S_ADDR) begin
            read_mux = 3'b101;
        end
        else if (addr == PTL_ADDR) begin
            read_mux = 3'b110;
        end
        else begin
            read_mux = 3'b000;
        end
    end
endmodule