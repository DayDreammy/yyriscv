`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/28 15:24:12
// Design Name: 
// Module Name: Branch_Comp
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
/* Branch Comparator */
`include "define.v"

module Branch_Comp(
    input [`reg_bus] bra_dataA_i,
    input [`reg_bus] bra_dataB_i,
    input BrUn,
    
    input [`inst_bus] inst_i,

    output PCSel
    );
    //little decode
     wire[8:0] inst={inst_i[30],inst_i[14:12],inst_i[6:2]};
     
      // I_type has two additional condition
   wire B_type=inst[4]&inst[3]&~inst[2]&~inst[1]&~inst[0];
   wire J_type=inst[4]&inst[3]&~inst[2]&inst[1]&inst[0];
   
    // B_type 6
    wire i_beq  =  B_type & ~inst[7] & ~inst[6] & ~inst[5];
    wire i_bne  =  B_type & ~inst[7] & ~inst[6] & inst[5];
    wire i_blt  =  B_type & inst[7] & ~inst[6] & ~inst[5];
    wire i_bge  =  B_type & inst[7] & ~inst[6] & inst[5];
    wire i_bltu =  B_type & inst[7] & inst[6] & ~inst[5];
    wire i_bgeu =  B_type & inst[7] & inst[6] & inst[5];
      // J_type 1 
   wire i_jal   =  J_type ;
   // I_type 
   wire I_type1=inst[4]&inst[3]&~inst[2]&~inst[1]&inst[0] ;
   wire i_jalr  =  I_type1 & ~inst[7] & ~inst[6] & ~inst[5];
    
    reg tem_BrLT;
    
    always@(*) begin
        if(BrUn) begin
              tem_BrLT = bra_dataA_i <  bra_dataB_i ? 1:0;
        end else begin
              tem_BrLT = $signed(bra_dataA_i) <  $signed(bra_dataB_i) ? 1:0;
        end
    end
    
    assign BrEQ = bra_dataA_i == bra_dataB_i ? 1:0;
    assign BrLT = tem_BrLT;
    
    // ex need not care ex_inst's jal or jalr ,just need to care decode_stage's jal or jalr
    assign PCSel     = (i_beq & BrEQ) | (i_bne & ~BrEQ) | (i_blt & BrLT)
                    | (i_bltu & BrLT)| (i_bge & ~BrLT)| (i_bgeu & ~BrLT) 
                    | i_jal | i_jalr;

endmodule
