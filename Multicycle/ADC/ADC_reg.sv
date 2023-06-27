//-----------------------------------------------------------------------------
// Title         : ADC Peripheral
//-----------------------------------------------------------------------------
// File          : ADC_reg.sv
// Author        : David Ramón Alamán
// Created       : 01.02.2023
//-----------------------------------------------------------------------------

module ADC_reg (
    input logic clk, chipSelect, read, rst, en,
    input logic addr, 
    output logic[31:0] channel0, channel1, readData
);
    
    logic[11:0] ch0, ch1;
	logic[31:0] registers[1:0];

    assign channel0 = {20'b0, ch0};
    assign channel1 = {20'b0, ch1};

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            registers <= '{default: '0};
        end
        else if (en) begin
            if(chipSelect) begin
                if(read) begin
                    readData <= registers[addr];
                end
            end

            registers[0] = {20'b0, ch0};
            registers[1] = {20'b0, ch1};
        end
    end

    ADC_block IP_block(
        .rst(rst),
        .clk(clk),
        .CH0(ch0),
        .CH1(ch1)
    );

endmodule