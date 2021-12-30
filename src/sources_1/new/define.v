`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/02 11:00:32
// Design Name: 
// Module Name: define
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

`define cpu_reset_addr 32'd0

`define mem_num 128  // memory depth(how many words)
`define mem_bus 31:0
`define mem_addr_bus 31:0

`define reg_addr_bus 4:0
`define reg_bus 31:0
`define reg_num 32

`define rst_enable 1'b1

`define inst_addr_bus 31:0
`define inst_bus 31:0

`define data_addr_bus 31:0
`define data_bus 31:0

`define imm_bus 31:0
`define immsel_bus 2:0

`define pcsel_bus 1:0

`define stall_bus 5:0
// immsel
`define I_type 3'b000
`define S_type 3'b001
`define B_type 3'b010
`define J_type 3'b011
`define R_type 3'b100
`define U_type 3'b101

// ALU orders
`define Add_i 4'b0000
`define Sub_i 4'b0001
`define Xor_i 4'b0010
`define Or_i  4'b0011
`define And_i 4'b0100
`define Sll_i 4'b0101
`define Srl_i 4'b0110
`define Sra_i 4'b0111
`define slt_i 4'b1001
`define sltiu_i 4'b1010
`define lui_i 4'b1011

`define alusel_bus 3:0
`define wbsel_bus 1:0

`define SIMULATION
`define simu_inst_num 128
`define simu_data_num 128

// pipeline forwarding
`define rs1_ex_o 2'b10
`define rs2_ex_o 2'b11
`define no_forw 0
`define forw_selbus 1:0



