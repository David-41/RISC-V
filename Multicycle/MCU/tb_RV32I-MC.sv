`timescale 1 ns / 1 ps

module tb_RV32I_MC();
    
    logic clk, rst, en;
    logic[1:0] pwm1out, pwm2out;
    logic[6:0] hex0, hex1, hex2, hex3, hex4, hex5;
    
    RV32I_MC #(
        .DEPTH(64),
        .PROGRAM_FILE("PID.hex")
    )RISCV(
        .clk(clk), 
        .rst(rst),
        .en(en), 
        .pwm1out(pwm1out),
        .pwm2out(pwm2out),
        .hex0(hex0),
        .hex1(hex1),
        .hex2(hex2),
        .hex3(hex3),
        .hex4(hex4),
        .hex5(hex5)
    );

    // Generate clock
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // Initialization
    initial begin
        en = 0;
        rst = 0; #7 rst = 1;
        en = 1;
    end
endmodule