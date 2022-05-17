/*****************************************************************************   
                      
Filename        : imm_gen.v
Author          : Sai Gautham Ravipati (EE19B053)
Date            : 10th October 2021 
Description     : Used to generate imm./other values and give operands of ALU
                  
                  Inputs - 
                  - instr. => 32-bit instruction (idata[31:0]). 
                  - rd_data1 => Data of source register-1 from reg_file.
                  - rd_data2 => Data of source register-2 from reg_file. 
                  - pc => Current value of program counter (iaddr). 
                  - alu_src => Used to select ALU operands between imm./other
                               values and source registers. 
                  - pc_sel => Used to select between pc and 32{1'b0}, for ops
                              like JAL, JALR and AUIPC.  
                              
                  Outputs -
                  - ra => 32-bit operand-1 of ALU
                  - rb => 32-bit operand-2 of ALU   
                  
                  Finally operands to the ALU are selected based the control 
                  signals. 
                  
Note on JAL, JALR, AUIPC, LUI : 

- For JAL and JALR, pc is taken as imm_data1 and constant val. 4 as imm_data2
  and the ALU is used to compute PC+4 and same is stored in destination reg. 
- For AUIPC, pc istaken as imm_data1 and imm_data2 comes from the instr. bits,
  and ALU computes the some to store in destination reg.   
- For LUI, imm_data1 is set to 0, as pc_sel is 0 and alu_src[0] is 1. So this
  is equivalent to addition of zero in the ALU, and same shall be loaded to
  the destination register in next iteration. 
- For all these operation alu_op is 00, so it corresponds to addition in ALU. 
            
*****************************************************************************/ 

module imm_gen( 
    input [31:0] instr, 
    input [31:0] rd_data1, 
    input [31:0] rd_data2,
    input [31:0] pc, 
    input [1:0] alu_src, 
    input pc_sel, 
    output [31:0] rb,
    output [31:0] ra
);
    
    reg [31:0] imm_data2;    
    reg [31:0] imm_data1; 
    
    always @(*) begin 
        case(instr[6:0]) 
            7'b0000011:  imm_data2 = {{20{instr[31]}},instr[31:20]};                                                                //Load 
            7'b0100011:  imm_data2 = {{20{instr[31]}},instr[31:25],instr[11:7]};                                                    //Store 
            7'b0010011:  imm_data2 = ((instr[13:12] == 2'b01) ? ({{27{1'b0}},instr[24:20]}) : ({{20{instr[31]}},instr[31:20]}));    //ALU - Shamt/Imm. Value 
            7'b0010111:  imm_data2 = {instr[31:12],{12{1'b0}}};                                                                     //AUIPC
            7'b0110111:  imm_data2 = {instr[31:12],{12{1'b0}}};                                                                     //LUI
            7'b1101111:  imm_data2 = 32'd4;                                                                                         //JAL
            7'b1100111:  imm_data2 = 32'd4;                                                                                         //JALR
            default:     imm_data2 = {32{1'b0}};                                                                                    //Default set to zero
        endcase 
        imm_data1 = (pc_sel ?  pc : {32{1'b0}});    //Selects between pc and zero 
    end 
    
    assign rb = ((alu_src[1] == 1) ? imm_data2 : rd_data2);    //ALU operand-2 
    assign ra = ((alu_src[0] == 1) ? imm_data1 : rd_data1);    //ALU operand-1
    
endmodule          
