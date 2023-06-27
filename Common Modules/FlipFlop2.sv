//----------------------------------------------------------------------------------------------
// Title         : Synchronous and Asynchronous Flip flop with enable with 2 inputs and outputs
//----------------------------------------------------------------------------------------------
// File          : FlipFlop2.sv
// Author        : David Ramón Alamán
// Created       : 16.10.2022
//----------------------------------------------------------------------------------------------

module FlipFlop2 #(
    parameter WIDTH = 32
) (
    input logic clk, en, srst, arst,
    input logic[WIDTH - 1:0] d0, d1,
    output logic[WIDTH - 1:0] q0, q1
);

    always_ff @(posedge clk or negedge arst) begin 
        if(~arst) begin // Reset
            q0 <= 0; 
            q1 <= 0;
        end 
		  else if(~srst) begin // Reset
				q0 <= 0;
				q1 <= 0;
		  end
        else if(en) begin // If enable
            q0 <= d0;
            q1 <= d1;
        end
    end
endmodule