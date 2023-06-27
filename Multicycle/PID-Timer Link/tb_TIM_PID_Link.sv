module tb_TIM_PID_Link();
    
    // Signals definition
    logic clk, rst, en, cs, write, read;
    logic [31:0] writeData, readData, pid_in, compare1, compare2;

    // DUT
    PID_TIM_Link dut(
        .clk(clk), 
        .chipSelect(cs), 
        .write(write), 
        .read(read), 
        .rst(rst), 
        .en(en),
        .pid_in(pid_in),
        .writeData(writeData),
        .timOut1(compare1), 
        .timOut2(compare2),
        .readData(readData)
    );

    // Generate clock
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // Initialization
    initial begin
        en = 0;
        rst = 0;
        cs = 0;
        write = 0;
        read = 0;
        pid_in = 2048;
        writeData = 0;
        #7;
        rst = 1;
        en = 1;
        #10;
        pid_in = -2048;
        #10;
        pid_in = 2048;
        write = 1;
        cs = 1;
        writeData = 1;
        #10;
        write = 0;
        read = 1;
        pid_in = -2048;
        #10;
        write = 1;
        read = 0;
        writeData = 5;
        pid_in = 2048;
        #10;
        write = 0;
        read = 1;
        pid_in = -2048;
        #10;
        write = 1;
        read = 0;
        writeData = 10;
        pid_in = 2048;
        #10;
        write = 0;
        read = 1;
        pid_in = -2048;
    end

endmodule