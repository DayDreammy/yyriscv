`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/02 15:54:57
// Design Name: 
// Module Name: imem
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
`include "define.v"
/* instruction memory module */
module imem(
    input clk,
    input [`inst_addr_bus]  inst_addr,
    output [`inst_bus] inst_i
    );
    
    reg [`inst_addr_bus] _imem[0:`mem_num-1];
    
   
    
//   
    
//    always @ (*) begin
//        _imem[4] = 32'b0000000_00010_00001_000_00011_0110011;//add
//        _imem[8] = 32'b0100000_00010_00001_000_00011_0110011;//sub
//    end


//        `define IP_RAM//使用IP核
        `ifndef IP_RAM
         wire [`inst_addr_bus]addr=inst_addr>>2;
            `ifdef SIMULATION//编译仿真
        
        reg [`inst_addr_bus] mem[0:`simu_inst_num-1];
        reg [`inst_addr_bus] readmem[0:0];
        integer i=0;
        integer r,rfile,wfile;
  
        initial begin
            rfile = $fopen("E:/AX7020_2019/course_s1_fpga/riscvgcc/bin/maopao_sort.bin","rb");
            wfile = $fopen("E:/AX7020_2019/course_s1_fpga/riscvgcc/bin/maopao_sort.dat","w");
            while(!$feof(rfile))begin
                r = $fread(readmem,rfile);
                mem[i]={readmem[0][7:0],readmem[0][15:8],readmem[0][23:16],readmem[0][31:24]};
                $display("%x",mem[i]);
                $fwrite(wfile,"%x\n", mem[i]);
                i = i + 1;
            end
            $fclose(rfile);
            $fclose(wfile);
//         $readmemb("E:/AX7020_2019/course_s1_fpga/my_project/yy_riscv/instmem.dat",mem);
        end
        
        `else//文件txt里面读指令
            reg [`inst_addr_bus] mem[0:`simu_inst_num-1];
            initial begin
             $readmemb("E:/AX7020_2019/course_s1_fpga/my_project/yy_riscv/pipeinst.dat",mem);
            end
            assign inst_i=mem[addr];
        `endif
        
        assign inst_i=mem[addr];
        
        `else
              wire [6:0]addr=inst_addr[7:2];
              blk_mem_gen_0 imem (
                  .clka           (clk      ),  
                  .ena            (1'b1     ),      
                  .addra          (addr     ), 
                  .douta          (inst_i   ) 
              );
       `endif
        
//    `else
    
//     assign inst_i = _imem[addr];

//    `endif

endmodule
