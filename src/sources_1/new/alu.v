`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/02 18:15:20
// Design Name: 
// Module Name: alu
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
/* alu module */

`include "define.v"
module alu(
        input  [3:0] ALUsel,
        input ASel,
        input BSel,
        input [`inst_addr_bus] pc_i,
        input [`reg_bus] rs1_i,
        input [`reg_bus] rs2_i,
        input [`imm_bus] imm_i,
        
        output reg [`reg_bus] mem_wdata_o
    );
    
    
    
       // read_data1 mux
    wire [`reg_bus] read_data1;
    assign read_data1 = ( ASel == 1'b1 ) ? pc_i : rs1_i;
    // read_data2 mux
    wire [`reg_bus] read_data2;
    assign read_data2 = ( BSel == 1'b1 ) ? imm_i : rs2_i;
    
   always@(*) begin
     casex(ALUsel)
        `Add_i:
            mem_wdata_o = read_data1 + read_data2;
        `Sub_i:
            mem_wdata_o = read_data1 - read_data2;
        `Xor_i:
            mem_wdata_o = read_data1 ^ read_data2;
        `Or_i:
            mem_wdata_o = read_data1 | read_data2;
        `And_i:
            mem_wdata_o = read_data1 & read_data2;
        `Sll_i:
            mem_wdata_o = read_data1 << read_data2;
        `Srl_i:
            mem_wdata_o = read_data1 >> read_data2;
        `Sra_i:
            mem_wdata_o = $signed(read_data1) >>> read_data2;
        `slt_i :
           mem_wdata_o = $signed(read_data1) < $signed(read_data2) ? 1 : 0;
        `sltiu_i:
            mem_wdata_o = read_data1 < read_data2 ? 1 : 0;
        `lui_i:
            mem_wdata_o =  read_data2;
         default:
            mem_wdata_o = 0;
    endcase
   end
   
endmodule
