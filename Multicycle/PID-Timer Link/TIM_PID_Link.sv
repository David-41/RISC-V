//-----------------------------------------------------------------------------
// Title         : PID to Timer Link
//-----------------------------------------------------------------------------
// File          : PID_TIM_Link.sv
// Author        : David Ramón Alamán
// Created       : 25.05.2023
//-----------------------------------------------------------------------------

module PID_TIM_Link (
    input clk, chipSelect, write, read, rst, en,
    input logic[31:0] pid_in,
    input logic[31:0] writeData,
    output logic[31:0] timOut1, timOut2,
    output logic[31:0] readData
);

logic[31:0] register, compare;
assign compare = $signed(pid_in) >>> $signed(register);

always_ff @(posedge clk or negedge rst) begin
    if(!rst) begin
        register = 32'd0;
    end
    else begin
        if(chipSelect) begin
            if(write) begin
                register <= writeData;
            end
            else begin
                readData <= register;
            end
        end
    end
end

always_comb begin
    if($signed(pid_in) >= $signed(32'd0)) begin
        timOut1 = compare;
        timOut2 = 32'd0;
    end
    else begin
        timOut1 = 32'd0;
        timOut2 = -compare;
    end
end

endmodule