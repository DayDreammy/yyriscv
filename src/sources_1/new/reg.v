`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/02 16:39:16
// Design Name: 
// Module Name: reg
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
/* common registers */
`include "define.v"

module gprs(

    input                clk,
    input                RegWen,
    
    // register A
    input [`reg_addr_bus] raddrA_i,
    output reg[`reg_bus]  rdataA_o,
    // register B
    input [`reg_addr_bus] raddrB_i,
    output reg[`reg_bus]  rdataB_o,
    // register D
    input [`reg_addr_bus] waddrD_i,
    input [`reg_bus]      wdataD_i

    );
    
    reg [`reg_bus] regs[0:`reg_num-1];
   
    `ifndef SIMULATION
    initial  begin
        regs[1]=32'd2;
        regs[2]=32'd1;
        regs[4]=4'b1100;
        regs[5]=32'hffffffff;
        regs[6]=32'h0;
        regs[10]=32'd15;
        regs[20]=32'd666;
        regs[21]=32'd666;
    end
    `endif
    
    `ifdef SIMULATION
    integer i=0;
    initial begin
       while(i<32)begin
            regs[i]=32'd0;
            if(i==2)begin  // s0=10
                regs[i]=32'd100;
            end
            i = i+1;
       end
    end
    
    initial begin
        #30
        regs[2]=32'd100;
    end
    
    `endif
    
    // write register
    always @(posedge clk) begin
        if(RegWen == 1) begin
          if(waddrD_i != 0)begin // x0²»¿ÉÐ´
            regs[waddrD_i] <= wdataD_i;
          end
        end
    end

    // read register A
    always @(*) begin
        // if read when write the same source ,take write data directly£¨i.e. mem_wb forwarding£©
        if(  RegWen && ( raddrA_i == waddrD_i)  )begin
            rdataA_o = wdataD_i;
        end else begin//read reg normally
            rdataA_o = regs[raddrA_i];
        end
    end
    
    // read register B
    always @(*) begin
        // if read when write the same source ,take write data directly
        if( RegWen && ( raddrB_i == waddrD_i))begin
            rdataB_o = wdataD_i;
        end else begin
            rdataB_o = regs[raddrB_i];
        end
    end
    
    
    
    

    
    
    
endmodule
