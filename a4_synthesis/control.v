/*****************************************************************************   
                      
Filename        : control.v
Author          : Sai Gautham Ravipati (EE19B053)
Date            : 10th October 2021 
Description     : Main control unit of the ALU, generates various signals, 
                  based on the opcode of the instruction. 
                  
                  Inputs - 
                  - [6:0] instr. => Corresponds to the opcode idata[6:0] of 
                                    the instruction. 
                             
                  Outputs - 
                  - reg_wr => Written to register file when asserted.
                  - mem_wr => Written to memory when asserted. 
                  - mem_reg => Selects data from memory over alu_out when 
                               asserted.
                  - mem_read => Reads from memory when asserted. 
                  - alu_src => Two bit signal to select the operands of ALU. 
                  - alu_op => Used in generation of alu control signal, and 
                              acts as split between operations.
                  - pc_sel => Used specifically for AUIPC, JAL, JALR ops to
                              write PC to register. 
                              
                  If any of the cases don't match all are signals other than
                  alu_op are set to zero, while alu_op is set to one  which is
                  the default case in alu_control module. 
                    
*****************************************************************************/

module control( 
    input [6:0] instr, 
    output reg reg_wr, 
    output reg mem_wr, 
    output reg mem_reg, 
    output reg mem_read, 
    output reg [1:0] alu_src, 
    output reg [1:0] alu_op,
    output reg pc_sel 
);

    always @(*) begin 
        case(instr)
            7'b0000011: {reg_wr, mem_wr, mem_reg, mem_read, alu_src, alu_op, pc_sel} =  9'b101110000;    // Load
            7'b0100011: {reg_wr, mem_wr, mem_reg, mem_read, alu_src, alu_op, pc_sel} =  9'b010010000;    // Store
            7'b0010111: {reg_wr, mem_wr, mem_reg, mem_read, alu_src, alu_op, pc_sel} =  9'b100011001;    // AUIPC
            7'b0010011: {reg_wr, mem_wr, mem_reg, mem_read, alu_src, alu_op, pc_sel} =  9'b100010100;    // ALUI
            7'b0110011: {reg_wr, mem_wr, mem_reg, mem_read, alu_src, alu_op, pc_sel} =  9'b100000100;    // ALU
            7'b0110111: {reg_wr, mem_wr, mem_reg, mem_read, alu_src, alu_op, pc_sel} =  9'b100011000;    // LUI
            7'b1101111: {reg_wr, mem_wr, mem_reg, mem_read, alu_src, alu_op, pc_sel} =  9'b100011001;    // JAL
            7'b1100111: {reg_wr, mem_wr, mem_reg, mem_read, alu_src, alu_op, pc_sel} =  9'b100011001;    // JALR
            7'b1100011: {reg_wr, mem_wr, mem_reg, mem_read, alu_src, alu_op, pc_sel} =  9'b000000010;    // Branch (Cond.)
            default:    {reg_wr, mem_wr, mem_reg, mem_read, alu_src, alu_op, pc_sel} =  9'b000000110;    // Default sets only alu_op to 2'b11
        endcase 
    end 
    
endmodule 