`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/20 22:45:00
// Design Name: 
// Module Name: forw_ctrl
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
/* forwarding ctrl module */

`include "define.v"

module forw_ctrl(
    input rst,

    input [`inst_bus] forw_id_inst_i,
    input [`inst_bus] forw_ex_inst_i,
    input [`inst_bus] forw_mem_inst_i,
    
    input [`wbsel_bus] forw_ex_WBSel_i,
    input [`wbsel_bus] forw_mem_WBSel_i,
    input forw_ex_RegWen_i,
    input forw_mem_RegWen_i,
    
    //input regd
    input [`reg_bus] reg_dataA_i,
    input [`reg_bus] reg_dataB_i,
    
    //input forwi data
    input [`reg_bus] ex_alu_i,
    input [`reg_bus] mem_31sel_i,
    
    //output forwo data
    output reg [`reg_bus] forw_dataA_o,
    output reg [`reg_bus] forw_dataB_o,

    //input decode jal/jalr
    input de_jal_jalr_i,
    //stall output
    output reg [`stall_bus] stall
    );
    
   wire[4:0] rd = forw_id_inst_i[11:7];
   wire[4:0] rs1 = forw_id_inst_i[19:15];
   wire[4:0] rs2 = forw_id_inst_i[24:20];  
   
   wire[4:0] ex_rd = forw_ex_inst_i[11:7];
   wire[4:0] mem_rd = forw_mem_inst_i[11:7];
   wire ex_we=forw_ex_RegWen_i;
   wire mem_we=forw_mem_RegWen_i;

   wire ex_is_load;
   wire mem_is_load;
   assign ex_is_load = ((forw_ex_WBSel_i == 0) && forw_ex_RegWen_i);
   assign mem_is_load = ((forw_mem_WBSel_i == 0) && forw_mem_RegWen_i);
   assign stage_id_stallreq= (ex_is_load && (rs1 == ex_rd  ||  rs2 == ex_rd )) ;
   assign stage_if_stallreq=de_jal_jalr_i;
                        
   /* forwarding dataA control */
   always@(*) begin
        if( ex_rd &&  ( ex_we )  && ( rs1 == ex_rd ) )begin
            forw_dataA_o=ex_alu_i;
        end else if( mem_rd &&  ( mem_we )  && ( rs1 == mem_rd ) )begin
            forw_dataA_o=mem_31sel_i;
        end else begin
            forw_dataA_o=reg_dataA_i;
        end 
   end
   
   /* forwarding dataB control */
   always@(*) begin
        if( ex_rd &&  ( ex_we )  && ( rs2 == ex_rd ) )begin
            forw_dataB_o=ex_alu_i;
        end else if( mem_rd &&  ( mem_we )  && ( rs2 == mem_rd ) )begin
            forw_dataB_o=mem_31sel_i;
        end else begin
            forw_dataB_o=reg_dataB_i;
        end 
   end
   
// stall[0] PC
// stall[1] IF
// stall[2] ID
// stall[3] EX
// stall[4] MEM
// stall[5] WB

   always@(*) begin
        if(!rst) begin
			stall <= 6'b000000;
        end else if( stage_id_stallreq ) begin //stage id stallreq.
            stall <= 6'b000111;
//        end else if( stage_if_stallreq ) begin //stage if stallreq.
//            stall <= 6'b000011;
        end else begin
            stall <= 6'b000000;
        end 
   end

endmodule
