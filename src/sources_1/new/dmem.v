`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/28 09:32:55
// Design Name: 
// Module Name: dmem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "define.v"
/* data memory module */

module dmem(
    input                    clk,
    input  [`data_addr_bus]  data_addr,
    input                    MemRW,
    input  [`inst_bus]       inst_i,
    input  [`data_bus]       dataw_i,
    output reg[`data_bus]    datar_o
    );
    
   
    
    // mem from inital data
     `ifndef SIMULATION 
        reg [`data_addr_bus] mem[0:`simu_data_num-1];
        initial begin
             $readmemb("E:/AX7020_2019/course_s1_fpga/my_project/yy_riscv/datamem.dat",mem);
        end
        wire [`data_bus] dmem_read= mem[data_addr];
 
    `else
        reg [`data_addr_bus] _imem[0:`mem_num-1];
    
        wire [`data_bus] dmem_read=  _imem[data_addr];
    `endif
    
    
    reg [`data_bus] data_write;
    
    // load / store dmem out type
    wire[6:0] opcode = inst_i[6:2];
    wire[2:0] funct3 = inst_i[14:12];
  //  wire[1:0] mem_addr_index=inst_i & 2'b11;
    
    //read dmem 
    always@(*) begin
        if(opcode == 5'b00000)begin //load
            casex(funct3)
                3'b000:begin// I lb
                       datar_o = {{24{dmem_read[7]}}, dmem_read[7:0]};
                end 
                3'b001:begin// I lh
                       datar_o = {{16{dmem_read[15]}}, dmem_read[15:0]};
                end 
                3'b010:begin// I lw
                       datar_o=dmem_read;
                end 
                3'b100:begin// I lbu
                       datar_o = {24'h0, dmem_read[7:0]};
                 
                end 
                3'b101:begin// I lhu
                       datar_o = {16'h0, dmem_read[15:0]};
                end
                default:begin //lw
                       datar_o=dmem_read;
                end
            endcase
        end
    end
    
    //store
    always@(*) begin
        if(opcode == 5'b01000)begin //store
            casex(funct3)
                3'b000:begin// S sb
                  data_write =  {24'h0 , dataw_i[7:0]};
                end
                3'b001:begin// S sh
                   data_write = { 16'h0 ,dataw_i[31:16]};
                end
                3'b010:begin// S sw
                    data_write=dataw_i;
                end
                default:begin // S sw
                    data_write=dataw_i;
                end
            endcase
        end
    end

     `ifndef SIMULATION 
    // write dmem
     always @(posedge clk) begin
        if(MemRW == 1) begin
          mem[data_addr] <= data_write;
        end
     end
     
     `else
     
     always @(posedge clk) begin
        if(MemRW == 1) begin
          _imem[data_addr] <= data_write;
        end
     end
        
    `endif

endmodule
