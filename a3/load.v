/*****************************************************************************   
                      
Filename        : load.v
Author          : Sai Gautham Ravipati (EE19B053)
Date            : 10th October 2021 
Description     : Gives the value to be stored to register for the next clk
                  after selecting between alu_out and data from memory. 
                  
                  Inputs - 
                  - mem_read => Reads from memeory if asserted to 1.
                  - mem_reg => Selects between mem. data and alu_out. 
                  - func3 => Corresponds to idata[14:12] of the instruction.  
                  - alu_out => Output of alu, can be both addr. or data.
                  - rd_data => Data chunk provided by dmem module.  
                  
                  Outputs -
                  - reg_wr_data => Data to be written to reg. file, selected
                                   between alu_out and data memory. 
                  
                  Note that the default value of mem. data is set to 32{1'b0}. 
                  
*****************************************************************************/

module load( 
    input mem_read,
    input mem_reg, 
    input [2:0] func3,
    input [31:0] alu_out, 
    input [31:0] rd_data, 
    output reg [31:0] reg_wr_data
);
    
    reg [31:0] wr_data; 
    
    always @(*) begin 
        if(mem_read) begin
            case(func3)    
                3'b000:        // LB
                    begin    
                        case(alu_out[1:0])
                            2'b00: 
                                wr_data = {{24{rd_data[7]}},rd_data[7:0]}; 
                            2'b01:
                                wr_data = {{24{rd_data[15]}},rd_data[15:8]};
                            2'b10: 
                                wr_data = {{24{rd_data[23]}},rd_data[23:16]};
                            2'b11: 
                                wr_data = {{24{rd_data[31]}},rd_data[31:24]}; 
                            default:
                                wr_data = {32{1'b0}}; 
                        endcase 
                    end 
                3'b001:        // LH 
                    begin    
                        case(alu_out[1:0])
                            2'b00:
                                wr_data = {{16{rd_data[15]}},rd_data[15:0]};
                            2'b10:
                                wr_data = {{16{rd_data[31]}},rd_data[31:24]}; 
                            default: wr_data = {32{1'b0}}; 
                        endcase 
                    end 
                3'b010:        // LW                   
                    wr_data = (alu_out[1:0] == 2'b00) ? rd_data : 0; 
                3'b100:        // LBU
                    begin   
                        case(alu_out[1:0])
                            2'b00: 
                                wr_data = {{24{1'b0}},rd_data[7:0]}; 
                            2'b01:
                                wr_data = {{24{1'b0}},rd_data[15:8]};
                            2'b10: 
                                wr_data = {{24{1'b0}},rd_data[23:16]};
                            2'b11: 
                                wr_data = {{24{1'b0}},rd_data[31:24]}; 
                            default: 
                                wr_data = {32{1'b0}}; 
                        endcase 
                    end 
                3'b101:        // LHU 
                    begin    
                        case(alu_out[1:0])
                            2'b00:
                                wr_data = {{16{1'b0}},rd_data[15:0]};
                            2'b10:
                                wr_data = {{16{1'b0}},rd_data[31:24]}; 
                            default:
                                wr_data = {32{1'b0}}; 
                        endcase 
                end 
                default:
                    wr_data = {32{1'b0}}; 
            endcase
            
        end 
        else 
            wr_data = {32{1'b0}}; 
        
        reg_wr_data = ( mem_reg ? wr_data : alu_out);    // Selecting between alu_out and mem. data 
    end 

endmodule 