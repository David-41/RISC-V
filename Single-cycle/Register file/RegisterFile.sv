//-----------------------------------------------------------------------------
// Title         : Register File
//-----------------------------------------------------------------------------
// File          : RegisterFile.sv
// Author        : David Ramón Alamán
// Created       : 17.09.2022
//-----------------------------------------------------------------------------

module RegisterFile(
    input logic clk, we, rst,
    input logic[4:0] reg1, reg2, reg3,
    input logic[31:0] dataIn,
    output logic[31:0] regData1, regData2 
);
    
    logic[31:0] registers[31:0];

    // Asynchronous read
    assign regData1 = (reg1 != 0) ? registers[reg1] : 32'b0;
    assign regData2 = (reg2 != 0) ? registers[reg2] : 32'b0;

    // Synchronous write
    always_ff @(posedge clk or negedge rst) begin 
        if (~rst) begin
            registers <= '{default: '0};
        end
        else if(we) begin // Write enable
            registers[reg3] <= dataIn;
        end
    end
    
endmodule