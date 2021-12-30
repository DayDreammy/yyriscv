`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/19 09:23:23
// Design Name: 
// Module Name: reg_id_ex
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
/* reg inst decode to execute */
`include "define.v"

module reg_id_ex(
    input wire clk,
    input wire rst,
    input [`stall_bus] stall,
    input [`inst_addr_bus] id_pc_i,   //id pc in 
    input br,//branch
    
    input [`reg_bus]  id_opv1_i,
    input [`reg_bus]  id_opv2_i,
    input [`imm_bus] id_inst_i,
    input [`immsel_bus] id_Immsel_i,//ctrl
    input id_RegWen_i,
    input id_BrUn_i,
    input id_ASel_i,
    input id_BSel_i,
    input [`alusel_bus] id_ALUsel_i,
    input id_MemRW_i,
    input [`wbsel_bus] id_WBSel_i,
    
    output reg [`inst_addr_bus] ex_pc_o,   //ex pc out
    output reg [`reg_bus]  ex_opv1_o,
    output reg [`reg_bus]  ex_opv2_o,
    output reg [`imm_bus] ex_inst_o,
    output reg [`immsel_bus] ex_Immsel_o,//ctrl
    output reg ex_RegWen_o,
    output reg ex_BrUn_o,
    output reg ex_ASel_o,
    output reg ex_BSel_o,
    output reg [`alusel_bus] ex_ALUsel_o,
    output reg ex_MemRW_o,
    output reg [`wbsel_bus] ex_WBSel_o
    
    );
    
      
                        
    /* reg inst decode to execute */
     always @ ( posedge clk ) begin
        if( !rst ||  br ||(stall[2] && !stall[3])) begin
            ex_pc_o <= 0;
            ex_inst_o <= 0;
            ex_opv1_o <= 0;
            ex_opv2_o <= 0;
           
            ex_Immsel_o <= 0;//ctrl
            ex_RegWen_o <= 0;
            ex_BrUn_o <= 0;
            ex_ASel_o <= 0;
            ex_BSel_o <= 0;
            ex_ALUsel_o <= 0;
            ex_MemRW_o <= 0;
            ex_WBSel_o <= 0;
        end
        else if( !stall[2] ) begin
            ex_pc_o   <= id_pc_i;
            ex_opv1_o <= id_opv1_i;
            ex_opv2_o <= id_opv2_i;
            ex_inst_o  <= id_inst_i;
            ex_Immsel_o <= id_Immsel_i;//ctrl
            ex_RegWen_o <= id_RegWen_i;
            ex_BrUn_o <= id_BrUn_i;
            ex_ASel_o <= id_ASel_i;
            ex_BSel_o <= id_BSel_i;
            ex_ALUsel_o <= id_ALUsel_i;
            ex_MemRW_o <= id_MemRW_i;
            ex_WBSel_o <= id_WBSel_i;
        end
    end
    
endmodule//reg_id_ex

