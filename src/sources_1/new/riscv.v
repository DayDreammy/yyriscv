`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/19 15:26:12
// Design Name: 
// Module Name: riscv
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
/*  decode  module */
`include "define.v"

module riscv(
    input [`inst_bus] inst_i,
    input BrEQ,
    input BrLT,
    
    output jalr_or_jal,
    output [`immsel_bus] Immsel,
    output BrUn,
    output ASel,
    output BSel,
    output [`alusel_bus] ALUsel,
    output MemRW,
    output RegWen,
    output [`wbsel_bus] WBSel,
    
    //reg
    output [`reg_addr_bus] raddrB_o,
    output [`reg_addr_bus] raddrA_o,
    output [`reg_addr_bus] waddr_o
    );
    
   wire[8:0] inst={inst_i[30],inst_i[14:12],inst_i[6:2]};
   wire[4:0] rd = inst_i[11:7];
   wire[4:0] rs1 = inst_i[19:15];
   wire[4:0] rs2 = inst_i[24:20];  
   
   wire inst_zero= (inst_i == 0);//check bubble inst
   
    
   /*     define opcode format       */
   wire U_type1 = ~inst[4] & inst[3] & inst[2] & ~inst[1] & inst[0] ;
   wire U_type2 = ~inst[4] & ~inst[3] & inst[2] & ~inst[1] & inst[0] ;
   wire J_type=inst[4]&inst[3]&~inst[2]&inst[1]&inst[0];
   wire I_type1=inst[4]&inst[3]&~inst[2]&~inst[1]&inst[0] ;
   wire I_type2=~inst[4]&~inst[3]&~inst[2]&~inst[1]&~inst[0] ;
   wire I_type3=~inst[4]&~inst[3]&inst[2]&~inst[1]&~inst[0];
    // I_type has two additional condition
   wire B_type=inst[4]&inst[3]&~inst[2]&~inst[1]&~inst[0];
   wire S_type=~inst[4]&inst[3]&~inst[2]&~inst[1]&~inst[0];
   wire R_type=~inst[4]&inst[3]&inst[2]&~inst[1]&~inst[0];
  
   // U_type 2 
   wire i_lui   =  U_type1;
   wire i_auipc =  U_type2;
   
   // J_type 1 
   wire i_jal   =  J_type ;
   
   // I_type 15
   wire i_jalr  =  I_type1 & ~inst[7] & ~inst[6] & ~inst[5];
   wire i_lb    =  I_type2 & ~inst[7] & ~inst[6] & ~inst[5];
   wire i_lh    =  I_type2 & ~inst[7] & ~inst[6] & inst[5];
   wire i_lw    =  I_type2 & ~inst[7] & inst[6] & ~inst[5];
   wire i_lbu   =  I_type2 & inst[7] & ~inst[6] & ~inst[5];
   wire i_lhu   =  I_type2 & inst[7] & ~inst[6] & inst[5];
   wire i_addi  =  I_type3 & ~inst[7] & ~inst[6] & ~inst[5];
   wire i_slti  =  I_type3 & ~inst[7] & inst[6] & ~inst[5];
   wire i_sltiu =  I_type3 & ~inst[7] & inst[6] & inst[5];
   wire i_xori  =  I_type3 & inst[7] & ~inst[6] & ~inst[5];
   wire i_ori   =  I_type3 & inst[7] & inst[6] & ~inst[5];
   wire i_andi  =  I_type3 & inst[7] & inst[6] & inst[5];
   wire i_slli  =  I_type3 & ~inst[8] & ~inst[7] & ~inst[6] & inst[5];
   wire i_srli  =  I_type3 & ~inst[8] & inst[7] & ~inst[6] & inst[5];
   wire i_srai  =  I_type3 & inst[8] & inst[7] & ~inst[6] & inst[5];
   
    // B_type 6
    wire i_beq  =  B_type & ~inst[7] & ~inst[6] & ~inst[5];
    wire i_bne  =  B_type & ~inst[7] & ~inst[6] & inst[5];
    wire i_blt  =  B_type & inst[7] & ~inst[6] & ~inst[5];
    wire i_bge  =  B_type & inst[7] & ~inst[6] & inst[5];
    wire i_bltu =  B_type & inst[7] & inst[6] & ~inst[5];
    wire i_bgeu =  B_type & inst[7] & inst[6] & inst[5];
    
    // S_type 3
    wire i_sb   =  S_type & ~inst[7] & ~inst[6] & ~inst[5];
    wire i_sh   =  S_type & ~inst[7] & ~inst[6] & inst[5];
    wire i_sw   =  S_type & ~inst[7] & inst[6] & ~inst[5];
   
   // R_type 10 
   wire i_add   =  R_type & ~inst[8] & ~inst[7] & ~inst[6] & ~inst[5];
   wire i_sub   =  R_type & inst[8] & ~inst[7] & ~inst[6] & ~inst[5];
   wire i_sll   =  R_type & ~inst[8] & ~inst[7] & ~inst[6] & inst[5];
   wire i_slt   =  R_type & ~inst[8] & ~inst[7] & inst[6] & ~inst[5];
   wire i_sltu  =  R_type & ~inst[8] & ~inst[7] & inst[6] & inst[5];
   wire i_xor   =  R_type & ~inst[8] & inst[7] & ~inst[6] & ~inst[5];
   wire i_srl   =  R_type & ~inst[8] & inst[7] & ~inst[6] & inst[5];
   wire i_sra   =  R_type & inst[8] & inst[7] & ~inst[6] & inst[5];
   wire i_or    =  R_type & ~inst[8] & inst[7] & inst[6] & ~inst[5];
   wire i_and   =  R_type & ~inst[8] & inst[7] & inst[6] & inst[5];
   
    /*     define output operator       */
   // pipeline mode ,decode stage just judge jual or jalr
   assign jalr_or_jal     =  i_jalr | i_jal;
   assign Immsel[2] = i_auipc | i_lui;
   assign Immsel[1] = J_type | B_type;
   assign Immsel[0] = J_type | i_auipc | i_lui | S_type;
   assign BrUn      = i_bltu | i_bgeu;
   assign ASel      = B_type | J_type | i_auipc;
   assign BSel      = I_type3 |  I_type2 |  I_type1 |  J_type  
                    | U_type2 |  U_type1 |  B_type  |  S_type;
   assign ALUsel[3] = i_lui | i_slt | i_sltu | i_slti | i_sltiu;
   assign ALUsel[2] = i_sll | i_srl | i_sra | i_and | i_slli
                    | i_srli | i_srai | i_andi;
   assign ALUsel[1] = i_sltu | i_xor | i_or | i_srl | i_sra
                    | i_sltiu | i_xori | i_ori | i_srli | i_srai| i_lui;
   assign ALUsel[0] = i_sub | i_sll | i_slt | i_sra| i_or| i_slli 
                    | i_slti| i_srai| i_ori | i_lui;
   assign MemRW     = S_type;
   assign RegWen    = !inst_zero & ( R_type |  I_type3 |  I_type2 |  I_type1 |  J_type  
                    | U_type2 |  U_type1 );
   assign WBSel[1]  = i_jal | i_jalr;
   assign WBSel[0]  = R_type | i_auipc | i_lui | I_type3;
   
   assign waddr_o=rd;
   assign raddrA_o=rs1;
   assign raddrB_o=rs2;
 
endmodule
