/*****************************************************************************   
                      
Filename        : reg_file.v
Author          : Sai Gautham Ravipati (EE19B053)
Date            : 10th October 2021 
Description     : 32(32-bit) register file of the CPU  
                  
                  Inputs - 
                  - rd_reg1 => 5-bit address of source register-1. 
                  - rd_reg2 => 5-bit address of source register-2.
                  - wr_reg => 5-bit address of destination register. 
                  - reg_wr_data => 32-bit data to be written to register. 
                  - reg_wr => Control signal which acts like a write enable. 
                  - clk => Clock of the CPU, as write process in synchornous.
                  - reset => On reset registers are set to zero. 
                  
                  Outputs -
                  - rd_data1 => Contents of source register-1
                  - rd_data2 => Contents of source register-2  
                  
                  All the registers are initialised to zero and are reset to 
                  zero. Data is written only to registers other than x0. 

*****************************************************************************/

module reg_file( 
    input [4:0] rd_reg1, 
    input [4:0] rd_reg2, 
    input [4:0] wr_reg, 
    input [31:0] reg_wr_data, 
    input reg_wr, 
    input clk, 
    input reset, 
    output [31:0] rd_data1, 
    output [31:0] rd_data2 
); 
    
    reg [31:0] reg_array [0:31];    // 32 (32-bit) register array 
    
    integer i; 
    initial begin
        for(i = 0; i < 32; i = i + 1) 
            reg_array[i] = {32{1'b0}};    // Intialising registers to zero  
    end 
    
    assign rd_data1 = reg_array[rd_reg1];    // Driving the contents at rd_reg1 to source register-1 
    assign rd_data2 = reg_array[rd_reg2];    // Driving the contents at rd_reg2 to source register-2 
    
    integer j;                              
    always @(posedge clk) begin 
        if(reset) begin
            for(j = 0; j < 32; j = j + 1) 
                reg_array[j] <= {32{1'b0}};    // Regesiters are synchornously reset to zero
        end                         
        else if(reg_wr && (wr_reg != 0))
            reg_array[wr_reg] <= reg_wr_data;    // Data in written on next clk to dest. register (except x0) on asserting reg_wr to 1 
    end 
    
endmodule  