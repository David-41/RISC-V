//--------------------------------------------------------------
// Title         : PID Peripheral
//--------------------------------------------------------------
// File          : PID_Reg.sv
// Author        : David Ramon Alaman
// Created       : 24.12.2022
//--------------------------------------------------------------

module PID_Reg #(
    parameter PRESCALER_DEFAULT_VALUE = 1
) (
    input logic clk, chipSelect, write, read, rst, en,
    input logic [3:0] addr,
    input logic [31:0] writeData, feedback_bypass,
    output logic [31:0] readData, control_bypass
);
    
    logic pid_en, clk_en;
    logic[31:0] feedback;
    logic[31:0] registers[11:0];
    logic[31:0] control_sat;
	logic[31:0] control_reg;
    //registers[0]  --> Reference        (R(k))
    //registers[1]  --> PID ctt. 1       (k1)
    //registers[2]  --> PID ctt. 2       (k2)
    //registers[3]  --> PID ctt. 3       (k3)
    //registers[4]  --> Feedback         (F(k))          (Bypass) 
    //registers[5]  --> Clk prescaler    
    //registers[6]  --> Status           (Active/Stop)
    //registers[7]  --> Clear PID    
    //registers[8]  --> Bypass feedback   
    //registers[9]  --> Saturation       (Enabled/Disabled)
    //registers[10] --> Upper saturation
    //registers[11] --> Lower saturation

    //address 12    --> Control action   (U(k)) 

    assign pid_en = en & registers [6][0] & clk_en;
    assign feedback = registers[8] ? feedback_bypass : registers[4];
    assign control_bypass = registers[9] ? control_reg : control_sat;

    always_comb begin
        if(control_reg > registers[10]) begin
            control_sat = registers[10];
        end
        else if (control_reg < registers[11]) begin
            control_sat = registers [11];
        end
        else begin
            control_sat = control_reg;
        end
    end

    always_ff @(posedge clk or negedge rst) begin
        if(!rst) begin
            registers <= '{default: '0};
        end
        else begin
            if(chipSelect) begin
                if (write) begin
                    if(addr < 12) begin
                        registers [addr] <= writeData;
                    end
                end
                else if(read) begin
                    if(addr < 12) begin
                        readData <= registers[addr];
                    end
                    else if(addr === 12) begin
                        if(registers[9]) begin
                            readData <= control_reg;
                        end
                        else begin
                            readData <= control_sat;
                        end
                    end
                end
            end
        end
    end

    PID pid(
        .clk(clk),
        .en(pid_en),
        .arst(rst),
        .srst(~registers[7][0]),
        .reference(registers[0]),
        .feedback(feedback),
        .k1(registers[1]),
        .k2(registers[2]),
        .k3(registers[3]),
        .control(control_reg)
    );

    Prescaler #(
        .INITIAL_VALUE(PRESCALER_DEFAULT_VALUE)
    ) prescaler (
        .clk(clk),
        .arst(rst),
        .en(en),
        .new_value(registers[5]),
        .clk_en(clk_en)
    );

endmodule