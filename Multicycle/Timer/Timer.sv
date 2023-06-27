//-----------------------------------------------------------------------------
// Title         : Timer Peripheral
//-----------------------------------------------------------------------------
// File          : Timer.sv
// Author        : David Ramón Alamán
// Created       : 24.01.2023
//-----------------------------------------------------------------------------

module Timer #(
    parameter PRESCALER_DEFAULT_VALUE = 1
) (
    input logic clk, chipSelect, write, read, rst, en,
    input logic[4:0] addr,
    input logic[31:0] writeData, bypass1, bypass2,
    output logic[1:0] pwm1out, pwm2out,
    output logic[31:0] readData
);

    logic tim_en, clk_en, pwm1, pwmn1, pwm2, pwmn2;
    logic[31:0] compare1, compare2;
    logic[31:0] registers[9:0]; 
    //registers[0] --> Count 
    //registers[1] --> ARR 
    //registers[2] --> Start 
    //registers[3] --> IRQ
    //registers[4] --> Prescaler
    //registers[5] --> Dead time
    //registers[6] --> Compare 1
    //registers[7] --> Compare 2
    //registers[8] --> Output enable -> 0(disabled) 1(enable)
        // registers[8][0] -> PWM 1 enable
        // registers[8][1] -> PWMN 1 enable (PWM 1 must be enabled)
        // registers[8][2] -> PWM 2 enable 
        // registers[8][3] -> PWMN 2 enable (PWM 2 must be enabled)
    //registers[9] --> Bypass

    assign tim_en = registers[2][0] & en & clk_en;
    assign pwm1out[0] = registers[8][0] ? pwm1 : 1'bz;
    assign pwm1out[1] = (registers[8][1] & registers[8][0]) ? pwmn1 : 1'bz;
    assign pwm2out[0] = registers[8][2] ? pwm2 : 1'bz;
    assign pwm2out[1] = (registers[8][3] & registers[8][2]) ? pwmn2 : 1'bz;
    assign compare1 = registers[9] ? bypass1 : registers[6];
    assign compare2 = registers[9] ? bypass2 : registers[7];

    always_ff @(posedge clk or negedge rst) begin
        if(!rst) begin
            registers <= '{default: '0};
        end
        else if (en) begin
            
            if(chipSelect) begin
                if (~(write && (addr == 4'b0))) begin
                    registers[0] <= tim_en ? (registers[0] + 1) : registers[0];
                end
                
                if (write) begin
                    registers[addr] <= writeData;
                end
                else if (read) begin
                    readData <= registers[addr];
                end  
            end
            else begin
                registers[0] <= tim_en ? (registers[0] + 1) : registers[0];
            end
            if(registers[0] >= (registers[1] - 1) && tim_en == 1) begin
                registers[0] <= '0;
                registers[3] <= 32'h0000_0001;
            end 
        end
    end

    Prescaler #(
        .INITIAL_VALUE(PRESCALER_DEFAULT_VALUE)
    ) prescaler (
        .clk(clk),
        .arst(rst),
        .en(en),
        .new_value(registers[4]),
        .clk_en(clk_en)
    );

    PWMGenerator PWMGen1 (
        .value(registers[5][7:0]),
        .count(registers[0]), 
        .compare(compare1), 
        .maxval(registers[1]),
        .pwm(pwm1), 
        .pwmn(pwmn1)
    );

    PWMGenerator PWMGen2 (
        .value(registers[5][7:0]),
        .count(registers[0]), 
        .compare(compare2), 
        .maxval(registers[1]),
        .pwm(pwm2), 
        .pwmn(pwmn2)
    );
    
endmodule