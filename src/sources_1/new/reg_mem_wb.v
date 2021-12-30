`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/19 09:53:03
// Design Name: 
// Module Name: reg_mem_wb
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
/* reg mem to write back */
`include "define.v"

module reg_mem_wb(
    input wire clk,
    input wire rst,
    input [`stall_bus] stall,
    
    input [`inst_addr_bus] mem_pc_i,
    input [`reg_bus] mem_aluop_i,
    input [`wbsel_bus] mem_WBSel_i,
    input mem_RegWen_i,
    input [`inst_bus] mem_regw_addr_i,
    input [`reg_bus] mem_regw_data_i,
    
    output reg[`reg_addr_bus] wb_regw_addr_o,
    output reg[`reg_bus] wb_regw_data_o,
    output reg wb_RegWen_o,
    
    output reg [`reg_bus] wb_data31_o

    );
    
    wire [`reg_addr_bus] wb_addr ;
    assign wb_addr= mem_regw_addr_i[11:7];
    // regd write back 1/3 mux
    wire [`data_bus] wb_regd_data;
    assign wb_regd_data=( mem_WBSel_i == 2'b10) ? (mem_pc_i+4) :
                        ( mem_WBSel_i == 2'b01 ) ? mem_aluop_i:mem_regw_data_i;
                        
    always@(*) begin
        wb_data31_o<=wb_regd_data;
    end
    
    always @ ( posedge clk ) begin
//      reset
        if( !rst || (stall[4] && !stall[5])) begin
            wb_regw_addr_o   <= 0;
            wb_regw_data_o   <= 0;
            wb_RegWen_o      <= 0;
        end else if( !stall[4] ) begin
            wb_regw_addr_o  <= wb_addr;
            wb_regw_data_o  <= wb_regd_data;
            wb_RegWen_o     <= mem_RegWen_i;
        end
    end

endmodule//reg_ex_mem
