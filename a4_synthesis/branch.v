/*****************************************************************************   
                      
Filename        : branch.v
Author          : Sai Gautham Ravipati (EE19B053)
Date            : 10th October 2021 
Description     : Generates target address for branch operations both cond. 
                  and unconditional. 
                  
                  Inputs - 
                  - pc => Current value of program counter (iaddr). 
                  - instr. => 32-bit instruction (idata[31:0]). 
                  - rd_data1 => Source register-1 from the register file. 
                  - alu_out => alu_out used to check for branch cond. 
                  
                  Outputs - 
                  - pc_out => The computed instruction addr. for branch. 
                  
                  By default pc_out is set to pc + 4. 
                 
*****************************************************************************/

module branch( 
    input [31:0] pc,
    input [31:0] instr,
    input [31:0] rd_data1,
    input [31:0] alu_out, 
    output [31:0] pc_out
); 
    
    reg [31:0] br_addr;
    reg branch; 
    
    always @(*) begin 
        case(instr[6:0]) 
            7'b1100011: begin        // BEQ,BNE,BLT,BGE,BLTU,BGEU
                br_addr = pc + {{21{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};    // Computing target addr.   
                case(instr[14:12])
                    3'b000: branch = (alu_out == 0);    // BEQ - SUB op in ALU
                    3'b001: branch = (alu_out != 0);    // BNE - SUB op in ALU
                    3'b100: branch = (alu_out != 0);    // BLT - SLT op in ALU
                    3'b101: branch = (alu_out == 0);    // BGE - SLT op in ALU 
                    3'b110: branch = (alu_out != 0);    // BLTU - SLTU op in ALU
                    3'b111: branch = (alu_out == 0);    // BGEU - SLTU op in ALU
                    default: branch = 0;                // Default value of branch signal 
                endcase 
            end 
            7'b1101111: begin        // JAL
                br_addr = pc + {{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};  
                branch = 1; 
            end 
            7'b1100111: begin        // JALR
                br_addr = rd_data1 + {{20{instr[31]}},instr[31:20]};  
                branch = 1; 
            end 
            default: begin           // Default case 
                br_addr = pc + 4; 
                branch = 0; 
            end 
        endcase 
    end 
    
    assign pc_out = branch ? br_addr : (pc + 4);      // Selecting branch addr. based on value of branch signal
    
endmodule 