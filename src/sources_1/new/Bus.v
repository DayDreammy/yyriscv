`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Bus(Req, Wdata, Addr, WREN, Instr, Rdata, slave_Wdata, slave_Addr, slave_Instr, Wen, slave1_Rdata, sel1);
input Req;       //总线访问权信号

input [31:0] Wdata;     //主设备写数据;
input [31:0] Addr;      //主设备访问从设备地址
input WREN;             //主设备写使能
input [31:0] Instr;     //指令信号
output [31:0] Rdata;    //主设备读数据

output [31:0] slave_Wdata;     //从设备写数据
output [31:0] slave_Addr;      //从设备读写数据地址
output [31:0] slave_Instr;     //从设备接收指令信息
output Wen;                    //从设备写使能
input [31:0] slave1_Rdata;     //从设备读数据
output sel1;                   //从设备工作使能
/////////////////////////////////////////////////////////////////////////////////////
reg [31:0] Rdata;
reg Wen;
reg [31:0] slave_Wdata;
reg [31:0] slave_Addr;
reg [31:0] slave_Instr;
reg sel1;

always @ (*)
begin
  if(Req == 1)
  begin
    slave_Wdata = Wdata;
    slave_Addr = Addr;
    slave_Instr = Instr;
    
    Rdata = slave1_Rdata;
    if(WREN == 1) begin
      Wen = 1; end
    else begin
      Wen = 0; end  
  end
  
  else
  begin
    Wen = 0;
    sel1 = 0;
    slave_Wdata = Wdata;
    slave_Addr = Addr;
    slave_Instr = Instr;
    Rdata = slave1_Rdata;
  end
end

endmodule
