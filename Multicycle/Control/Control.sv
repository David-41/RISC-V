//-----------------------------------------------------------------------------
// Title         : Control module
//-----------------------------------------------------------------------------
// File          : Control.sv
// Author        : David Ramón Alamán
// Created       : 16.10.2022
//-----------------------------------------------------------------------------

module Control(
    input logic clk, arst, en, branch,
    input logic[6:0] opCode,
    output logic PCRegEN, FetchRegEN, RFRegEN, ALUOutRegEN, DataRegEN, PCRegRST, FetchRegRST, RFRegRST,
        ALUOutRegRST, memWE, Regwe, InstructionRead,
    output logic[1:0] ALUIn1Src, ALUIn2Src, ResultSrc, ALUOp
);

    typedef enum logic [3:0] {Fetch, Decode, ExecuteR, ExecuteI, 
        ExecuteLui, ExecuteAuipc, PCUpdateI, PCUpdateJ,
        RdCalculation, Comparison, RegisterWrite, PCUpdateB,
        memoryAddr, memoryRead, memoryWrite, memoryWriteBack
        } statetype;
    statetype state, nextstate;

    // State register
    always_ff @(posedge clk or negedge arst) begin
        if(~arst) state <= Fetch;
        else if(en) state <= nextstate;
    end

    // Next state logic
    always_comb begin
        case(state) 
            Fetch: nextstate = Decode;
            Decode: 
                case(opCode)
                    7'b0000011, 7'b0100011: nextstate = memoryAddr;
                    7'b0010011: nextstate = ExecuteI;
                    7'b0110011: nextstate = ExecuteR;
                    7'b0010111: nextstate = ExecuteAuipc;
                    7'b0110111: nextstate = ExecuteLui;
                    7'b1100111: nextstate = PCUpdateI;
                    7'b1101111: nextstate = PCUpdateJ;
                    7'b1100011: nextstate = Comparison;
                    default: nextstate = Fetch;
                endcase
            memoryAddr: 
                if(opCode[5]) nextstate = memoryWrite;
                else nextstate = memoryRead;
            memoryWrite: nextstate = Fetch;
            memoryRead: nextstate = memoryWriteBack;
            memoryWriteBack: nextstate = Fetch;
            ExecuteR: nextstate = RegisterWrite;
            ExecuteI: nextstate = RegisterWrite;
            ExecuteAuipc: nextstate = RegisterWrite;
            ExecuteLui: nextstate = RegisterWrite;
            PCUpdateI: nextstate = RdCalculation;
            PCUpdateJ: nextstate = RdCalculation;
            RdCalculation: nextstate = RegisterWrite;
            RegisterWrite: nextstate = Fetch;
            Comparison: 
                if(branch) nextstate = PCUpdateB;
                else nextstate = Fetch;
            PCUpdateB: nextstate = Fetch;
            default: nextstate = Fetch;
        endcase
    end

    // Output logic
    always_comb begin
        case(state)
            Fetch: begin
                PCRegEN = 1'b1;
                FetchRegEN = 1'b1;
                InstructionRead = 1'b1;
                RFRegEN = 1'b0;
                ALUOutRegEN = 1'b0;
                DataRegEN = 1'b0;

                PCRegRST = 1'b1;
                FetchRegRST = 1'b1;
                RFRegRST = 1'b1;
                ALUOutRegRST = 1'b1;

                ALUIn1Src = 2'b11;
                ALUIn2Src = 2'b10;
                ResultSrc = 2'b01;

                memWE = 1'b0;
                Regwe = 1'b0;

                ALUOp = 2'b10;
            end

            Decode: begin
                PCRegEN = 1'b0;
                FetchRegEN = 1'b0;
                InstructionRead = 1'b0;
                RFRegEN = 1'b1;
                ALUOutRegEN = 1'b0;
                DataRegEN = 1'b0;

                PCRegRST = 1'b1;
                FetchRegRST = 1'b1;
                RFRegRST = 1'b1;
                ALUOutRegRST = 1'b1;

                ALUIn1Src = 2'b00;
                ALUIn2Src = 2'b00;
                ResultSrc = 2'b00;

                memWE = 1'b0;
                Regwe = 1'b0;

                ALUOp = 2'b00;
            end

            memoryAddr: begin
                PCRegEN = 1'b0;
                FetchRegEN = 1'b0;
                InstructionRead = 1'b0;
                RFRegEN = 1'b0;
                ALUOutRegEN = 1'b1;
                DataRegEN = 1'b0;

                PCRegRST = 1'b1;
                FetchRegRST = 1'b1;
                RFRegRST = 1'b1;
                ALUOutRegRST = 1'b1;

                ALUIn1Src = 2'b00;
                ALUIn2Src = 2'b00;
                ResultSrc = 2'b00;

                memWE = 1'b0;
                Regwe = 1'b0;

                ALUOp = 2'b10;
            end

            memoryRead: begin
                PCRegEN = 1'b0;
                FetchRegEN = 1'b0;
                InstructionRead = 1'b0;
                RFRegEN = 1'b0;
                ALUOutRegEN = 1'b0;
                DataRegEN = 1'b1;

                PCRegRST = 1'b1;
                FetchRegRST = 1'b1;
                RFRegRST = 1'b1;
                ALUOutRegRST = 1'b1;

                ALUIn1Src = 2'b00;
                ALUIn2Src = 2'b00;
                ResultSrc = 2'b00;

                memWE = 1'b0;
                Regwe = 1'b0;

                ALUOp = 2'b00;
            end

            memoryWriteBack: begin
                PCRegEN = 1'b0;
                FetchRegEN = 1'b0;
                InstructionRead = 1'b0;
                RFRegEN = 1'b0;
                ALUOutRegEN = 1'b0;
                DataRegEN = 1'b0;

                PCRegRST = 1'b1;
                FetchRegRST = 1'b1;
                RFRegRST = 1'b1;
                ALUOutRegRST = 1'b1;

                ALUIn1Src = 2'b00;
                ALUIn2Src = 2'b00;
                ResultSrc = 2'b10;

                memWE = 1'b0;
                Regwe = 1'b1;

                ALUOp = 2'b00;
            end

            memoryWrite: begin
                PCRegEN = 1'b0;
                FetchRegEN = 1'b0;
                InstructionRead = 1'b0;
                RFRegEN = 1'b0;
                ALUOutRegEN = 1'b0;
                DataRegEN = 1'b0;

                PCRegRST = 1'b1;
                FetchRegRST = 1'b1;
                RFRegRST = 1'b1;
                ALUOutRegRST = 1'b1;

                ALUIn1Src = 2'b00;
                ALUIn2Src = 2'b00;
                ResultSrc = 2'b00;

                memWE = 1'b1;
                Regwe = 1'b0;

                ALUOp = 2'b00;
            end

            ExecuteR: begin
                PCRegEN = 1'b0;
                FetchRegEN = 1'b0;
                InstructionRead = 1'b0;
                RFRegEN = 1'b0;
                ALUOutRegEN = 1'b1;
                DataRegEN = 1'b0;

                PCRegRST = 1'b1;
                FetchRegRST = 1'b1;
                RFRegRST = 1'b1;
                ALUOutRegRST = 1'b1;

                ALUIn1Src = 2'b00;
                ALUIn2Src = 2'b01;
                ResultSrc = 2'b00;

                memWE = 1'b0;
                Regwe = 1'b0;

                ALUOp = 2'b00;
            end

            ExecuteI: begin
                PCRegEN = 1'b0;
                FetchRegEN = 1'b0;
                InstructionRead = 1'b0;
                RFRegEN = 1'b0;
                ALUOutRegEN = 1'b1;
                DataRegEN = 1'b0;

                PCRegRST = 1'b1;
                FetchRegRST = 1'b1;
                RFRegRST = 1'b1;
                ALUOutRegRST = 1'b1;

                ALUIn1Src = 2'b00;
                ALUIn2Src = 2'b00;
                ResultSrc = 2'b00;

                memWE = 1'b0;
                Regwe = 1'b0;

                ALUOp = 2'b00;
            end

            ExecuteAuipc: begin
                PCRegEN = 1'b0;
                FetchRegEN = 1'b0;
                InstructionRead = 1'b0;
                RFRegEN = 1'b0;
                ALUOutRegEN = 1'b1;
                DataRegEN = 1'b0;

                PCRegRST = 1'b1;
                FetchRegRST = 1'b1;
                RFRegRST = 1'b1;
                ALUOutRegRST = 1'b1;

                ALUIn1Src = 2'b10;
                ALUIn2Src = 2'b00;
                ResultSrc = 2'b00;

                memWE = 1'b0;
                Regwe = 1'b0;

                ALUOp = 2'b10;
            end

            ExecuteLui: begin
                PCRegEN = 1'b0;
                FetchRegEN = 1'b0;
                InstructionRead = 1'b0;
                RFRegEN = 1'b0;
                ALUOutRegEN = 1'b1;
                DataRegEN = 1'b0;

                PCRegRST = 1'b1;
                FetchRegRST = 1'b1;
                RFRegRST = 1'b1;
                ALUOutRegRST = 1'b1;

                ALUIn1Src = 2'b01;
                ALUIn2Src = 2'b00;
                ResultSrc = 2'b00;

                memWE = 1'b0;
                Regwe = 1'b0;

                ALUOp = 2'b10;
            end

            PCUpdateI: begin
                PCRegEN = 1'b1;
                FetchRegEN = 1'b0;
                InstructionRead = 1'b0;
                RFRegEN = 1'b0;
                ALUOutRegEN = 1'b0;
                DataRegEN = 1'b0;

                PCRegRST = 1'b1;
                FetchRegRST = 1'b1;
                RFRegRST = 1'b1;
                ALUOutRegRST = 1'b1;

                ALUIn1Src = 2'b00;
                ALUIn2Src = 2'b00;
                ResultSrc = 2'b01;

                memWE = 1'b0;
                Regwe = 1'b0;

                ALUOp = 2'b10;
            end

            PCUpdateJ: begin
                PCRegEN = 1'b1;
                FetchRegEN = 1'b0;
                InstructionRead = 1'b0;
                RFRegEN = 1'b0;
                ALUOutRegEN = 1'b0;
                DataRegEN = 1'b0;

                PCRegRST = 1'b1;
                FetchRegRST = 1'b1;
                RFRegRST = 1'b1;
                ALUOutRegRST = 1'b1;

                ALUIn1Src = 2'b10;
                ALUIn2Src = 2'b00;
                ResultSrc = 2'b01;

                memWE = 1'b0;
                Regwe = 1'b0;

                ALUOp = 2'b10;
            end

            RdCalculation: begin
                PCRegEN = 1'b0;
                FetchRegEN = 1'b0;
                InstructionRead = 1'b0;
                RFRegEN = 1'b0;
                ALUOutRegEN = 1'b1;
                DataRegEN = 1'b0;

                PCRegRST = 1'b1;
                FetchRegRST = 1'b1;
                RFRegRST = 1'b1;
                ALUOutRegRST = 1'b1;

                ALUIn1Src = 2'b10;
                ALUIn2Src = 2'b10;
                ResultSrc = 2'b00;

                memWE = 1'b0;
                Regwe = 1'b0;

                ALUOp = 2'b10;
            end

            Comparison: begin
                PCRegEN = 1'b0;
                FetchRegEN = 1'b0;
                InstructionRead = 1'b0;
                RFRegEN = 1'b0;
                ALUOutRegEN = 1'b0;
                DataRegEN = 1'b0;

                PCRegRST = 1'b1;
                FetchRegRST = 1'b1;
                RFRegRST = 1'b1;
                ALUOutRegRST = 1'b1;

                ALUIn1Src = 2'b00;
                ALUIn2Src = 2'b01;
                ResultSrc = 2'b00;

                memWE = 1'b0;
                Regwe = 1'b0;

                ALUOp = 2'b01;
            end

            PCUpdateB: begin
                PCRegEN = 1'b1;
                FetchRegEN = 1'b0;
                InstructionRead = 1'b0;
                RFRegEN = 1'b0;
                ALUOutRegEN = 1'b0;
                DataRegEN = 1'b0;

                PCRegRST = 1'b1;
                FetchRegRST = 1'b1;
                RFRegRST = 1'b1;
                ALUOutRegRST = 1'b1;

                ALUIn1Src = 2'b10;
                ALUIn2Src = 2'b00;
                ResultSrc = 2'b01;

                memWE = 1'b0;
                Regwe = 1'b0;

                ALUOp = 2'b10;
            end

            RegisterWrite: begin
                PCRegEN = 1'b0;
                FetchRegEN = 1'b0;
                InstructionRead = 1'b0;
                RFRegEN = 1'b0;
                ALUOutRegEN = 1'b0;
                DataRegEN = 1'b0;

                PCRegRST = 1'b1;
                FetchRegRST = 1'b1;
                RFRegRST = 1'b1;
                ALUOutRegRST = 1'b1;

                ALUIn1Src = 2'b00;
                ALUIn2Src = 2'b00;
                ResultSrc = 2'b00;

                memWE = 1'b0;
                Regwe = 1'b1;

                ALUOp = 2'b00;
            end

        endcase
    end
    
endmodule