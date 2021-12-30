`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/19 09:09:06
// Design Name: 
// Module Name: reg_if_id
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
/* reg_if_id modile */
`include "define.v"

module reg_if_id(
    input wire clk,
    input wire rst,
    input [`inst_addr_bus] pc_i,   //pc in 
    input [`stall_bus] stall,
    input [`inst_bus] inst_i,
    input br,//branch
    
    output reg [`inst_addr_bus] id_pc_o,
    output reg [`inst_bus] id_inst_o
    );
    /* reg_if_id modile */
    always @ ( posedge clk ) begin
//      reset
        if( !rst || br ||(stall[1] && !stall[2])) begin
            id_pc_o <= 32'd0;
            id_inst_o <= 32'd0;
        end
        else if( !stall[1] ) begin
            id_pc_o <= pc_i;
            id_inst_o <= inst_i;
        end
    end
    
endmodule//reg_if_id
