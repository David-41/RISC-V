//-----------------------------------------------------------------------------
// Title         : Pulse Width Modulation generator with dead time
//-----------------------------------------------------------------------------
// File          : PWMGenerator.sv
// Author        : David Ramón Alamán
// Created       : 25.01.2023
//-----------------------------------------------------------------------------

module PWMGenerator(
    input logic[7:0] value,
    input logic[31:0] compare, maxval, count,
    output logic pwm, pwmn
);

logic[9:0] deadtime;

always_comb begin
    if (value <= 8'd127) begin
        deadtime = value;
    end
    else if (value <= 8'd191) begin
        deadtime = (64 + value[5:0]) * 2; 
    end 
    else if (value <= 8'd223) begin
        deadtime = (32 + value[4:0]) * 8;
    end
    else begin
        deadtime = (32 + value[4:0]) * 16;
    end

    if(count < compare) begin
        pwm = 1'b1;
    end
    else begin
        pwm = 1'b0;
    end

    if(count >= (compare + deadtime) && count < (maxval - deadtime)) begin
        pwmn = 1'b1;
    end
    else begin
        pwmn = 1'b0;
    end

end
    
endmodule