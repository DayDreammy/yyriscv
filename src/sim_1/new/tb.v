`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/20 18:37:44
// Design Name: 
// Module Name: tb
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
//`include "define.v"

module tb;

//internal sigals
reg clk;
reg rst;
wire [31:0] mem_wrb_data;
//reg [`inst_addr_bus] _imem[0:`mem_num-1];

//DUV instance
top top_tb(
    .clk     (clk   ),
    .rst     (rst   )
);


// reset setup
initial begin
  rst = 1'b0;
  #10;
  rst = 1'b1;
end

// clock init
initial begin
    clk=1'b0;
    forever #5
    clk=~clk;
end

endmodule
