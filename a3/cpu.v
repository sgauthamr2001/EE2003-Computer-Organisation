/*****************************************************************************   
                      
Filename        : cpu.v
Author          : Sai Gautham Ravipati (EE19B053)
Date            : 10th October 2021 
Description     : CPU module where all other sub-modules are instantiated and 
                  the same is interfaced with imem.v and dmem.v in test bench.
                  
                  Inputs -
                  - clk => clk signal. 
                  - reset => reset signal. 
                  - idata => Instuction data of current instr.
                  - drdata => Data chunk read from memory
                  
                  Outputs -
                  - iaddr => Computed addr. of next instruction. 
                  - daddr => Addr. of data to be fetched/stored. 
                  - dwdata => Data to be written to memory. 
                  - dwe => Write enable of memory byte chunks.  

Note : Implementation closely follows the architecture in Ch. 4 of the text,
       Computer Organization and Design RISC-V Edition: The Hardware/Software
       Interface, by David A. Patterson and John L. Hennesey. 
       
*****************************************************************************/

module cpu (
    input clk, 
    input reset,
    output [31:0] iaddr,
    input [31:0] idata,
    output [31:0] daddr,
    input [31:0] drdata,
    output [31:0] dwdata,
    output [3:0] dwe
);
    
    reg [31:0] iaddr;
    reg [31:0] daddr;
    reg [31:0] dwdata;
    reg [3:0]  dwe;
    
    wire reg_wr;                           // Written to register file when asserted.
    wire mem_wr;                           // Written to memory when asserted. 
    wire mem_reg;                          // Selects data from memory over alu_out when asserted.
    wire mem_read;                         // Reads from memory when asserted. 
    wire [1:0] alu_src;                    // Two bit signal to select the operands of ALU. 
    wire [1:0] alu_op;                     // Used in generation of alu_ctrl, acts as split between operations.
    wire pc_sel;                           // Used specifically for AUIPC, JAL, JALR,
    wire [3:0] alu_ctrl;                   // 4-bit control to select the operation of ALU. 
    wire [31:0] ra;                        // 32-bit operand-1 of the ALU.
    wire [31:0] rb;                        // 32-bit operand-2 of the ALU. 
    wire [31:0] rd_data1;                  // Contents of source register-1 of reg_file.
    wire [31:0] rd_data2;                  // Contents of source register-2 of reg_file.
    wire [31:0] reg_wr_data;               // Data to be written to reg. file.
    wire [31:0] mem_wr_data;               // Data to be written to memory. 
    wire [31:0] alu_out;                   // Output of ALU. 
    wire [3:0] wr_en;                      // Write enable for byte memory chunks. 
    wire [31:0] pc_out;                    // Instruction addr. for next cycle. 
    
    always @(posedge clk) begin
        if (reset) begin
            iaddr <= 0;
        end else begin 
            iaddr <= pc_out;
        end
    end
     
    // Instantiating several modules and connecting them 
    
    control m1(
        .instr(idata[6:0]),
        .reg_wr(reg_wr),
        .mem_wr(mem_wr),
        .mem_reg(mem_reg), 
        .mem_read(mem_read), 
        .alu_src(alu_src), 
        .alu_op(alu_op), 
        .pc_sel(pc_sel)
    );
        
    alu_control m2(
        .alu_op(alu_op), 
        .alu_src(alu_src), 
        .func7(idata[30]),
        .func3(idata[14:12]),
        .alu_ctrl(alu_ctrl)
    );  
    
    reg_file m3(
        .rd_reg1(idata[19:15]), 
        .rd_reg2(idata[24:20]),
        .wr_reg(idata[11:7]),
        .reg_wr_data(reg_wr_data),
        .reg_wr(reg_wr), 
        .clk(clk),
        .reset(reset), 
        .rd_data1(rd_data1),
        .rd_data2(rd_data2)
    );
    
    imm_gen m4(
        .instr(idata),
        .rd_data1(rd_data1),
        .rd_data2(rd_data2), 
        .pc(iaddr), 
        .alu_src(alu_src),
        .pc_sel(pc_sel), 
        .rb(rb),
        .ra(ra)
    );
    
    alu32 m5(
        .alu_ctrl(alu_ctrl), 
        .ra(ra),
        .rb(rb), 
        .alu_out(alu_out)
    ); 
    
    load m6(
        .mem_read(mem_read),
        .mem_reg(mem_reg),
        .func3(idata[14:12]),
        .alu_out(alu_out), 
        .rd_data(drdata), 
        .reg_wr_data(reg_wr_data)
    );
    
    store m7(
        .mem_wr(mem_wr), 
        .func3(idata[14:12]), 
        .rd_data2(rd_data2), 
        .alu_out(alu_out), 
        .wr_en(wr_en), 
        .mem_wr_data(mem_wr_data)
    );
    
    branch m8(
        .pc(iaddr), 
        .instr(idata), 
        .rd_data1(rd_data1), 
        .alu_out(alu_out), 
        .pc_out(pc_out)
    ); 
    
    // Connecting intermediate wires to outputs 

    always @(*) begin
        if (reset) begin
            daddr = 0;
            dwdata = 0;
            dwe = 0;
        end 
        else begin 
            daddr = alu_out;
            dwe = wr_en;
            dwdata = mem_wr_data; 
        end 
    end 
    
endmodule