/*****************************************************************************   
                      
Filename        : alu_control.v
Author          : Sai Gautham Ravipati (EE19B053)
Date            : 10th October 2021 
Description     : Generates the 4-bit control signal for ALU module to select 
                  the operation required for an instrunction.  
                  
                  Inputs - 
                  - alu_op => 2-bit line to select between: 
                    - LUI/AUIPC         --> 00 
                    - Load/Store        --> 00
                    - Branch (Uncond.)  --> 00
                    - Branch (Cond.)    --> 01
                    - ALU and ALU Imm.  --> 10
                    
                  - alu_src => 2-bit line to select the operands of ALU, used 
                               in this module to set the alu_ctrl for ALU imm.
                               operations, and only alu_src[1] is used. 
                   
                  - func7 => idata[30] part of the func7 in instr. encoding, 
                             used to set alu_ctrl for ALU imm. operations. 
                
                  - func3 => idata[14:12] part of instr., used to select the 
                             control for both ALU(all) and Branch(cond.) ops. 
                             
                  Output - 
                  - alu_ctrl => 4-bit control to select the operation of ALU. 
                  
                  If any of the cases don't match, alu_ctrl is set to 4'b1111
                  and this again corresponds to default case in ALU module. 
                    
*****************************************************************************/

module alu_control(
    input [1:0] alu_op, 
    input [1:0] alu_src, 
    input func7, 
    input [2:0] func3, 
    output reg [3:0] alu_ctrl
); 
    
    wire [4:0] ctrl_in; 
    assign ctrl_in = {func7,func3,alu_src[1]};    // Used to select within ALU operations 
    
    always @(*) begin 
        case(alu_op)
            2'b00: alu_ctrl = 4'b0000;    // L/S, LUI, AUIPC, JAL, JALR - ADD operation in ALU
            2'b01: begin 
                case(func3) 
                    3'b000, 3'b001: alu_ctrl = 4'b1000;    // BEQ, BNE - SUB Operation in ALU  
                    3'b100, 3'b101: alu_ctrl = 4'b0010;    // BLT, BGE - SLT Operation in ALU 
                    3'b110, 3'b111: alu_ctrl = 4'b0011;    // BLTU, BGEU - SLTU Operation in ALU 
                    default:        alu_ctrl = 4'b1111;    // Selects default case in ALU 
                endcase 
            end 
            2'b10: begin  
                case(ctrl_in) 
                    5'b00001, 5'b10001, 5'b00000: alu_ctrl = 4'b0000;    // ADDI (1,2) and ADD (3)  
                    5'b00010, 5'b00011:           alu_ctrl = 4'b0001;    // SLL (1) and SLLU (2) 
                    5'b10101, 5'b00101, 5'b00100: alu_ctrl = 4'b0010;    // SLTI (1,2) and SLT (3)
                    5'b10111, 5'b00111, 5'b00110: alu_ctrl = 4'b0011;    // SLTIU (1,2) and SLTU (3)
                    5'b11001, 5'b01001, 5'b01000: alu_ctrl = 4'b0100;    // XORI (1,2) and XOR 
                    5'b01011, 5'b01010:           alu_ctrl = 4'b0101;    // SRLI (1,2) and SRL (3) 
                    5'b11101, 5'b01101, 5'b01100: alu_ctrl = 4'b0110;    // ORI (1) and OR (2)  
                    5'b11111, 5'b01111, 5'b01110: alu_ctrl = 4'b0111;    // ANDI (1,2) and AND (3) 
                    5'b10000:                     alu_ctrl = 4'b1000;    // SUB (1) 
                    5'b11010, 5'b11011:           alu_ctrl = 4'b1101;    // SRA (1) and SRAI (2)
                    default:                      alu_ctrl = 4'b1111;    // Selects default case in ALU 
                endcase  
            end 
            default: alu_ctrl = 4'b1111;    // Selects default case in ALU 
        endcase 
    end 
    
endmodule 