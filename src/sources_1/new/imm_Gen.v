`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/10 20:31:07
// Design Name: 
// Module Name: imm_Gen
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
/* imm_Gen module */
`include "define.v"

module imm_Gen(
    input [`inst_bus] inst_i,
    input [2:0] Immsel_i,
    output [`imm_bus] imm_o
    );
    
    wire[8:0] inst={inst_i[30],inst_i[14:12],inst_i[6:2]};
    wire I_type3 = ~inst[4] & ~inst[3] & inst[2] & ~inst[1] & ~inst[0];
     
    wire i_slli  =  I_type3 & ~inst[8] & ~inst[7] & ~inst[6] & inst[5];
    wire i_srli  =  I_type3 & ~inst[8] & inst[7] & ~inst[6] & inst[5];
    wire i_srai  =  I_type3 & inst[8] & inst[7] & ~inst[6] & inst[5];
            
    reg [`imm_bus] temp_imm;
    
    // select imm
     always@(*) begin
        casex(Immsel_i)
            `I_type:
                begin
                if( i_slli || i_srli || i_srai ) begin
                    temp_imm[31:0]={{26'd0},inst_i[25:20]};
                end else begin
                    temp_imm[31:0]={{20{inst_i[31]}},inst_i[31:20]};
                end
                end
            `S_type:
                temp_imm[31:0]={{20{inst_i[31]}},inst_i[31:25],inst_i[11:7]};
            `B_type:
                temp_imm[31:0]={{20{inst_i[31]}},inst_i[7],inst_i[30:25],inst_i[11:8],{1'b0}};
            `J_type:
                temp_imm[31:0]={{12{inst_i[31]}},inst_i[19:12],inst_i[20],inst_i[30:21],{1'b0}};
            `R_type:
                temp_imm[31:0]={{20{inst_i[31]}},inst_i[31:20]};
            `U_type:
                temp_imm[31:0]={inst_i[31:12],{12'b0}};
            default:
                temp_imm[31:0]={{20{inst_i[31]}},inst_i[31:20]};
        endcase
     end
     
     assign imm_o[`imm_bus]=temp_imm[`imm_bus];
    
endmodule
    
    
//    always @(*) begin
        
//        if( i_slli || i_srli || i_srai ) begin
//             temp_imm[31:0]={{26'd0},inst_i[25:20]};
////             temp_imm[5:0]=inst_i[25:20];
////             temp_imm[31:6]='d0;
//        end else begin
//            temp_imm[31:0]={{20{inst_i[31]}},inst_i[31:20]};
//        end
//    end
    
 
