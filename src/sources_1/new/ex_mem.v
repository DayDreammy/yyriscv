`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/19 09:37:04
// Design Name: 
// Module Name: ex_mem
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
/* reg  execute  to mem access */
`include "define.v"

module reg_ex_mem(
    input wire clk,
    input wire rst,
    input [`stall_bus] stall,
    input [`inst_addr_bus] ex_pc_i,   //ex pc in 
    input [`reg_bus] ex_aluop_i,
    input [`reg_bus] ex_mem_datai,
    input [`inst_bus] ex_inst_i,
    input ex_MemRW_i,//ctrl
    input [`wbsel_bus] ex_WBSel_i,
    input ex_RegWen_i,
    
    output reg [`inst_addr_bus] mem_pc_o,   //ex pc in 
    output reg [`reg_bus] mem_aluop_o,
    output reg [`reg_bus] mem_mem_datao,
    output reg [`inst_bus] mem_inst_o,
    output reg mem_MemRW_o,//ctrl
    output reg [`wbsel_bus] mem_WBSel_o,
    output reg mem_RegWen_o,
    output reg Req
    
    );
    
    wire[4:0] opcode = ex_inst_i[6:2];   
    always @ (posedge clk) begin
        if(opcode == 5'b00000 || opcode == 5'b01000)
            Req <= 1;
        else
            Req <= 0;
    end
    
    always @ ( posedge clk ) begin
//      reset
        if( !rst || (stall[3] && !stall[4])) begin
            mem_pc_o      <= 0;
            mem_aluop_o   <= 0;
            mem_mem_datao <= 0;
            mem_inst_o    <= 0;
            mem_MemRW_o   <= 0;
            mem_WBSel_o   <= 0;
            mem_RegWen_o  <= 0;
        end
       else if( !stall[3] ) begin
            //Recalculate PC+4 in M stage to avoidsending both PC and PC+4 down pipeline
            mem_pc_o      <= ex_pc_i;
            mem_aluop_o   <= ex_aluop_i;
            mem_mem_datao <= ex_mem_datai;
            mem_inst_o    <= ex_inst_i;
            mem_MemRW_o   <= ex_MemRW_i;
            mem_WBSel_o   <= ex_WBSel_i;
            mem_RegWen_o  <= ex_RegWen_i;
        end
    end
 
endmodule//reg_ex_mem
