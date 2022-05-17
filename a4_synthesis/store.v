/*****************************************************************************   
                      
Filename        : store.v
Author          : Sai Gautham Ravipati (EE19B053)
Date            : 10th October 2021 
Description     : Generates both data and write enable to store data to 
                  memory. 
                  
                  Inputs - 
                  - mem_wr - Writing to memory takes place when asserted
                  - func3 => Corresponds to idata[14:12] of the instruction.  
                  - rd_data2 => Source register-2 of the register file. 
                  - alu_out => Corresponds to address computed by the ALU.
                  
                  Outputs - 
                  - wr_en => Write enable for every byte chunk of memory. 
                  - mem_wr_data => 32 bit memory chunk to be written. 
                  
                  By default write enable is set to 4'b0000, so no writing 
                  takes place. 
                 
*****************************************************************************/

module store( input mem_wr,
              input [2:0] func3,
              input [31:0] rd_data2, 
              input [31:0] alu_out, 
              output reg [3:0] wr_en, 
              output reg [31:0] mem_wr_data ); 
    
    
    always @(*) begin 
        if(mem_wr) begin
            
            case(func3)
                3'b000:        // SB 
                    begin 
                        case(alu_out[1:0])
                            2'b00: begin 
                                mem_wr_data = rd_data2;
                                wr_en = 4'b0001; 
                            end 
                            2'b01: begin 
                                mem_wr_data = rd_data2 << 8; 
                                wr_en = 4'b0010; 
                            end  
                            2'b10: begin 
                                mem_wr_data = rd_data2 << 16; 
                                wr_en = 4'b0100; 
                            end 
                            2'b11: begin 
                                mem_wr_data = rd_data2 << 24; 
                                wr_en = 4'b1000; 
                            end
                            default: begin 
                                mem_wr_data = {32{1'b0}}; 
                                wr_en = 4'b0000; 
                            end 
                        endcase
                    end  
                3'b001:        // SH
                    begin 
                        case(alu_out[1:0])
                            2'b00: begin 
                                mem_wr_data = rd_data2; 
                                wr_en = 4'b0011; 
                            end 
                            2'b10: begin 
                                mem_wr_data = rd_data2 << 16; 
                                wr_en = 4'b1100; 
                            end
                            default: begin 
                                mem_wr_data = {32{1'b0}}; 
                                wr_en = 4'b0000; 
                            end 
                        endcase
                    end 
                3'b010:        // SW 
                    begin 
                        case(alu_out[1:0])
                            2'b00: begin 
                                mem_wr_data = rd_data2; 
                                wr_en = 4'b1111; 
                            end 
                            default: begin 
                                mem_wr_data = {32{1'b0}}; 
                                wr_en = 4'b0000; 
                            end 
                        endcase 
                    end 
                default: 
                    begin 
                        mem_wr_data = {32{1'b0}}; 
                        wr_en = 4'b0000; 
                    end    
            endcase
            
        end 
        else begin 
            mem_wr_data = {32{1'b0}}; 
            wr_en = 4'b0000; 
        end    
    end    
            
endmodule 
