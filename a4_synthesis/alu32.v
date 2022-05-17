/*****************************************************************************   
                      
Filename        : alu32.v
Author          : Sai Gautham Ravipati (EE19B053)
Date            : 10th October 2021 
Description     : 32-bit Arthimetic Logic Unit 

                  Inputs - 
                  - alu_ctrl => 4-bit control to select the operation of ALU. 
                  - ra => 32-bit operand-1 of the ALU.
                  - rb => 32-bit operand-2 of the ALU. 
                  
                  Output -
                  - alu_out => 32-bit output of ALU, operation(ra,rb), default
                              value is set to 0.   
                              
                  Operations performed -
                  - OP_ indicates both OP and OPI (Immediate). 
                  - Each line has been commented with respective operation. 

*****************************************************************************/

module alu32( 
    input [3:0] alu_ctrl,  
    input [31:0] ra, 
    input [31:0] rb, 
    output reg [31:0] alu_out 
); 
    
    always @(*) begin
        case(alu_ctrl)
            4'b0000: alu_out = ra + rb;                                  // ADD_
            4'b0001: alu_out = ra << rb[4:0];                            // SLL_
            4'b0010: alu_out = $signed(ra) < $signed(rb);                // SLT_
            4'b0011: alu_out = $unsigned(ra) < $unsigned(rb);            // SLT_U
            4'b0100: alu_out = ra ^ rb;                                  // XOR_
            4'b0101: alu_out = ra >> rb[4:0];                            // SRL_
            4'b0110: alu_out = ra | rb;                                  // OR_
            4'b0111: alu_out = ra & rb;                                  // AND_ 
            4'b1000: alu_out = ra - rb;                                  // SUB
            4'b1101: alu_out = $signed(ra) >>> rb[4:0];                  // SRA_
            default: alu_out = {32{1'b0}};                               // Default being set to zero       
        endcase 
    end 
    
endmodule 