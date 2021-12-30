`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/02 11:00:10
// Design Name: 
// Module Name: pc_reg
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
/* pc register module */
`include "define.v"

module pc_reg(
    input wire clk,
    input wire rst,
    
    input [`stall_bus] stall,
    input [`pcsel_bus] PCSel,
    input [`inst_addr_bus] br_addr_i,
    
    //prediction
    input [`inst_addr_bus] pre_addr_i,
    input  [`inst_addr_bus]pc_ex_i,
    
    output reg[`inst_addr_bus] pc_o   //pc out pointer
    
    );
    
    reg [`inst_addr_bus] pc;
    /* pc register module */
    always @ ( posedge clk or negedge rst ) begin
        if( rst  && (PCSel == 1)) begin //alu_addr
            pc_o <= br_addr_i;
            pc <= br_addr_i;
        end else if(rst  && (PCSel == 2))begin//pre_addr
            pc_o <= pre_addr_i;
            pc <= pre_addr_i;
        end else if(rst  && (PCSel == 3))begin//pre_addr
            pc_o <= pc_ex_i+4;
            pc <= pc_ex_i+4;
        end else begin
            if( rst  && !stall[0]) begin //normal
                pc <= pc+4;
            end
            if(!rst) begin
                pc_o      <= 0;
                pc        <= 32'd4;
            end else if (!stall[0]) begin //如果stall，就不更新pc_o
                //$display("PC now: %h", pc);
                pc_o <= pc;
            end
       end
   end

endmodule
