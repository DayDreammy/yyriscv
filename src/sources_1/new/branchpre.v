  `timescale 1ns / 1ps
  //////////////////////////////////////////////////////////////////////////////////
  // Company: 
  // Engineer: 
  // 
  // Create Date: 2021/12/17 19:47:33
  // Design Name: 
  // Module Name: bp
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
  /* branch prediction */
  module branchpre(
      input wire clk,
      input wire rst,
      input[31:0]inst_if_i,//第一级给的指令
      input[31:0]inst_3,
      input[31:0]addr,//拿来预测用的地址
      input[31:0]real_addr,//真地址，第三极alu计算出的地址
      input branch_comparation,//1:跳 0：不跳
      output reg [31:0]prediction_addr,
      output reg clear_reg,//1：清  0：不清
      output reg [`pcsel_bus] PCSel//ALU:1 BP:2 PC+4:0
  );
  reg [31:0]offset;
  reg [2:0] PCSel_clk;
  reg [1:0] PCSel_x;
  reg clear_reg_clk;
  reg clear_reg_x;
  reg [1:0] beq_jump;
  reg [1:0] bne_jump;
  reg [1:0] blt_jump;
  reg [1:0] bge_jump;//101
  reg [1:0] bltu_jump;
  reg [1:0] bgeu_jump;
  reg [31:0]BHR[0:1];//预测地址寄存器队列

//强跳：11  跳：10  不跳：01  弱跳：00 

  initial begin
  beq_jump=2'b01;
  bne_jump=2'b10;
  blt_jump=2'b01;
  bge_jump=2'b10;
  bltu_jump=2'b01;
  bgeu_jump=2'b10;
  BHR[0][31:0]=32'b0;
  BHR[1][31:0]=32'b0;
  prediction_addr=32'b11111111111111111111111111111111;
  end

// check whether prediction is correct
  always@(posedge clk)
  begin
  if((inst_3[6:0]==7'b1100011||inst_3[6:0]==7'b1100111)||inst_3[6:0]==7'b1101111)//从第三级拿指令
    begin
        case(inst_3[6:0])
        7'b1101111:begin PCSel_clk<=0;clear_reg_clk<=0;end
        7'b1100111:begin   //jalr
                          if(BHR[0][31:0]!=32'b0&&BHR[1][31:0]!=32'b0&&BHR[0][31:0]==BHR[1][31:0])
                          begin
                          if(prediction_addr==real_addr)   //PC不用更新
                                                    begin
                                                    clear_reg_clk<=0;
                                                    PCSel_clk<=0;
                                                    end
                                  else              begin //PC更新
                                                    clear_reg_clk<=1;
                                                    PCSel_clk<=1;
                                                    BHR[0][31:0]<=BHR[1][31:0];
                                                    BHR[1][31:0]<=real_addr;
                                                    end  
                          end else begin clear_reg_clk<=1;PCSel_clk<=1; end
                    end
        7'b1100011:begin  //B-type
          case(inst_3[14:12])
          3'b000:case(beq_jump)//BEQ
                  2'b11:begin
                          if(branch_comparation==1) begin  clear_reg_clk<=0; beq_jump<=2'b11; //PC不用更新;
                           PCSel_clk<=0;
                          end
                                              else   begin clear_reg_clk<=1; beq_jump<=2'b10; 
                          PCSel_clk<=3;end//将第三级寄存器存的地址+4给到pc
                                          end
                                          
                  2'b10:begin 
                          if(branch_comparation==1) begin clear_reg_clk<=0;beq_jump<=2'b11;
                           PCSel_clk<=0;//PC不用更新;
                          end
                                          else    begin clear_reg_clk<=1; beq_jump<=2'b01;
                                          PCSel_clk<=3;end
                                          end
                                          
                  2'b01:begin 
                          if(branch_comparation==0) begin clear_reg_clk<=0; beq_jump<=2'b00;//PC不用更新;
                          PCSel_clk<=0;//PC不用更新;
                          end
                                          else  begin clear_reg_clk<=1; beq_jump<=2'b10;PCSel_clk<=3;end//将第三级寄存器算出的地址给到pc
                                          end
                                          
                2'b00:begin 
                          if(branch_comparation==0) begin clear_reg_clk<=0;beq_jump<=2'b00;//PC值不用更新;
                          PCSel_clk<=0;//PC不用更新;
                          end
                                          else  begin clear_reg_clk<=1; beq_jump<=2'b01;PCSel_clk<=3;end
                                          end      
          endcase
          
          3'b001:case(bne_jump)//BNE
                  2'b11:begin
                          if(branch_comparation==1) begin  clear_reg_clk<=0; bne_jump<=2'b11;
                           PCSel_clk<=0;//PC不用更新;
                          end
                                              else   begin clear_reg_clk<=1; bne_jump<=2'b10; PCSel_clk<=3;end
                                          end
                                          
                  2'b10:begin 
                          if(branch_comparation==1) begin clear_reg_clk<=0;bne_jump<=2'b11;
                          PCSel_clk<=0;//PC不用更新;
                          end
                                          else    begin clear_reg_clk<=1; bne_jump<=2'b01;PCSel_clk<=3;end
                                          end
                                          
                  2'b01:begin 
                          if(branch_comparation==0) begin clear_reg_clk<=0; bne_jump<=2'b00;
                          PCSel_clk<=0;//PC不用更新;
                          end
                                          else  begin clear_reg_clk<=1; bne_jump<=2'b10;PCSel_clk<=1;end
                                          end
                                          
                2'b00:begin 
                          if(branch_comparation==0) begin clear_reg_clk<=0;bne_jump<=2'b00;
                          PCSel_clk<=0;//PC值不用更新;
                          end
                                          else  begin clear_reg_clk<=1; bne_jump<=2'b01;PCSel_clk<=1;end
                                          end      
          endcase
          
        3'b100:case(blt_jump)//blt
                  2'b11:begin
                          if(branch_comparation==1) begin  clear_reg_clk<=0; blt_jump<=2'b11;
                          PCSel_clk<=0; //PC不用更新;
                          end
                                              else   begin clear_reg_clk<=1; blt_jump<=2'b10; PCSel_clk<=3;end
                                          end
                                          
                  2'b10:begin 
                          if(branch_comparation==1) begin clear_reg_clk<=0;blt_jump<=2'b11;
                          PCSel_clk<=0;//PC不用更新;
                          end
                                          else    begin clear_reg_clk<=1; blt_jump<=2'b01;PCSel_clk<=3;end
                                          end
                                          
                  2'b01:begin 
                          if(branch_comparation==0) begin clear_reg_clk<=0; blt_jump<=2'b00;
                          PCSel_clk<=0;//PC不用更新;
                          end
                                          else  begin clear_reg_clk<=1; blt_jump<=2'b10;PCSel_clk<=1;end
                                          end
                                          
                2'b00:begin 
                          if(branch_comparation==0) begin clear_reg_clk<=0;blt_jump<=2'b00;
                          PCSel_clk<=0;//PC值不用更新;
                          end
                                          else  begin clear_reg_clk<=1; blt_jump<=2'b01;PCSel_clk<=1;end
                                          end      
          endcase
          
          3'b101:case(bge_jump)//bge
                  2'b11:begin
                          if(branch_comparation==1) begin  clear_reg_clk<=0; bge_jump<=2'b11;
                          PCSel_clk<=0; //PC不用更新;
                          end
                                              else   begin clear_reg_clk<=1; bge_jump<=2'b10; PCSel_clk<=3;end
                                          end
                                          
                  2'b10:begin 
                          if(branch_comparation==1) begin clear_reg_clk<=0;bge_jump<=2'b11;
                          PCSel_clk<=0;//PC不用更新;
                          end
                                          else    begin clear_reg_clk=1'b1; bge_jump=2'b01;PCSel_clk=3;end
                                          end
                                          
                  2'b01:begin 
                          if(branch_comparation==0) begin clear_reg_clk<=0; bge_jump<=2'b00;
                          PCSel_clk<=0;//PC不用更新;
                          end
                                          else  begin clear_reg_clk<=1; bge_jump<=2'b10;PCSel_clk<=1;end
                                          end
                                          
                2'b00:begin 
                          if(branch_comparation==0) begin clear_reg_clk<=0;bge_jump<=2'b00;
                          PCSel_clk<=0;//PC值不用更新;
                          end
                                          else  begin clear_reg_clk<=1; bge_jump<=2'b01;PCSel_clk<=1;end
                                          end      
          endcase
          3'b110:case(bltu_jump)//bltu
                  2'b11:begin
                          if(branch_comparation==1) begin  clear_reg_clk=0; bltu_jump=2'b11; 
                          PCSel_clk=0;//PC不用更新;
                          end
                                              else   begin clear_reg_clk=1; bltu_jump=2'b10; PCSel_clk=3;end
                                          end
                                          
                  2'b10:begin 
                          if(branch_comparation==1) begin clear_reg_clk=0;bltu_jump=2'b11;
                          PCSel_clk=0;//PC不用更新;
                          end
                                          else    begin clear_reg_clk=1; bltu_jump=2'b01;PCSel_clk=3;end
                                          end
                                          
                  2'b01:begin 
                          if(branch_comparation==0) begin clear_reg_clk=0; bltu_jump=2'b00;
                          PCSel_clk=0;//PC不用更新;
                          end
                                          else  begin clear_reg_clk=1; bltu_jump=2'b10;PCSel_clk=1;end
                                          end
                                          
                2'b00:begin 
                          if(branch_comparation==0) begin clear_reg_clk=0;bltu_jump=2'b00;
                          PCSel_clk=0;//PC值不用更新;
                          end
                                          else  begin clear_reg_clk=1; bltu_jump=2'b01;PCSel_clk=1;end
                                          end      
          endcase
          
            3'b111:case(bgeu_jump)//bgeu
                  2'b11:begin
                          if(branch_comparation==1) begin  clear_reg_clk<=0; bgeu_jump=2'b11; 
                          PCSel_clk=0;//PC不用更新;
                          end
                                              else   begin clear_reg_clk<=1; bgeu_jump=2'b10; PCSel_clk<=3;end
                                          end
                                          
                  2'b10:begin 
                          if(branch_comparation==1) begin clear_reg_clk<=0;bgeu_jump=2'b11;
                          PCSel_clk=0;//PC不用更新;
                          end
                                          else    begin clear_reg_clk<=1; bgeu_jump=2'b01;PCSel_clk<=3;end
                                          end
                                          
                  2'b01:begin 
                          if(branch_comparation==0) begin clear_reg_clk<=0; bgeu_jump=2'b00;
                          PCSel_clk=0;//PC不用更新;
                          end
                                          else  begin clear_reg_clk<=1; bgeu_jump=2'b10;PCSel_clk=1;end
                                          end
                                          
                2'b00:begin 
                          if(branch_comparation==0) begin clear_reg_clk<=0;bgeu_jump=2'b00;
                          PCSel_clk=0;//PC值不用更新;
                          end
                                          else  begin clear_reg_clk<=1; bgeu_jump=2'b01;PCSel_clk=1;end
                                          end      
          endcase
        endcase //inst_3[14:12]
    end//1100111
    endcase//inst_3[6:0]
  end
  else begin PCSel_clk<=4;clear_reg_clk<=0;end
  end
  
  ////////////////////////////////////////////////////////////////////////////
  
  always@(*)
  begin
  if(!rst)
    begin
      beq_jump=2'b01;
      bne_jump=2'b10;
      blt_jump=2'b01;
      bge_jump=2'b10;//101
      bltu_jump=2'b01;
      bgeu_jump=2'b10;
      BHR[0][31:0]=32'b0;
      BHR[1][31:0]=32'b0;
    end
  else if((inst_if_i[6:0]==7'b1100011||inst_if_i[6:0]==7'b1101111)||inst_if_i[6:0]==7'b1100111)
    begin
        case(inst_if_i[6:0])//强跳>跳>不跳>弱跳
        7'b1101111:begin 
            offset[31:0]<={{12{inst_if_i[31]}},inst_if_i[19:12],inst_if_i[20],inst_if_i[30:21],{1'b0}};
            prediction_addr<=addr+offset;
            PCSel_x<=2;//JAL
        end
        7'b1100111:begin
              if(BHR[0][31:0]==32'b0)  //前两次不预测JALR
              begin
                  BHR[0][31:0]=real_addr;
                end
              
              else if(BHR[0][31:0]!=32'b0&&BHR[1][31:0]==32'b0)
              begin 
                  BHR[1][31:0]=real_addr;
              end
              
              else if(BHR[0][31:0]!=32'b0&&BHR[1][31:0]!=32'b0&&BHR[0][31:0]==BHR[1][31:0]) //两次结果一样则预测    
                begin
                  prediction_addr=BHR[1][31:0];
                  PCSel_x=2;
                end
              
              else if(BHR[0][31:0]!=32'b0&&BHR[1][31:0]!=32'b0&&BHR[0][31:0]!=BHR[1][31:0])//两次结果不一样则改变队列
                begin 
                    BHR[0][31:0]=BHR[1][31:0];
                    BHR[1][31:0]=real_addr;
                  end
              end//begin1100111
  7'b1100011:begin //B type
      offset[31:0]={{20{inst_if_i[31]}},inst_if_i[7],inst_if_i[30:25],inst_if_i[11:8],{1'b0}};
      case(inst_if_i[14:12])
        3'b000:case(beq_jump)//BEQ
            2'b11:begin prediction_addr=addr+offset; 
                        PCSel_x=2;//下一个地址由branch prediction给
                        
                                          end
                                          
            2'b10:begin prediction_addr=addr+offset; 
                        PCSel_x=2;
                        
                                          end
            2'b01:begin prediction_addr=addr+4; 
                        PCSel_x=2;
                        
                                          end
            2'b00:begin prediction_addr=addr+4; 
                        PCSel_x=2;
                        
                                          end//下面五个同理
            endcase
            
        3'b001:case(bne_jump)//BNE
              2'b11:begin prediction_addr=addr+offset; PCSel_x=2;
                        
                                          end
            2'b10:begin prediction_addr=addr+offset; PCSel_x=2;
                          
                                          end
            2'b01:begin prediction_addr=addr+4; PCSel_x=2;
                        
                                          end
            2'b00:begin prediction_addr=addr+4; PCSel_x=2;
                        
                                          end
            endcase
          
        3'b100:case(blt_jump)//BLT
            2'b11:begin prediction_addr<=addr+offset; PCSel_x<=2;
                                          end
            2'b10:begin prediction_addr<=addr+offset; PCSel_x<=2;
                                          end
            2'b01:begin prediction_addr<=addr+4; PCSel_x<=2;
                                          end
            2'b00:begin prediction_addr<=addr+4; PCSel_x<=2;                       
                                          end
            endcase
            
        3'b101:case(bge_jump)//BGE
              2'b11:begin prediction_addr<=addr+offset; PCSel_x<=2;
                          
                                          end
            2'b10:begin prediction_addr<=addr+offset; PCSel_x<=2;
                        
                                          end
            2'b01:begin prediction_addr<=addr+4; PCSel_x<=2;
                        
                                          end
            2'b00:begin prediction_addr<=addr+4; PCSel_x<=2;
                        
                                          end
            endcase
            
      3'b110:case(bltu_jump)//BLTU
              2'b11:begin prediction_addr<=addr+offset; PCSel_x<=2;
                          
                                          end
            2'b10:begin prediction_addr<=addr+offset; PCSel_x<=2;
                        
                                          end
            2'b01:begin prediction_addr<=addr+4; PCSel_x<=2;
                          
                                          end
          2'b00:begin prediction_addr<=addr+4; PCSel_x<=2;
                          
                                          end
            endcase
            
      3'b111:case(bgeu_jump)//BGEU
            2'b11:begin prediction_addr<=addr+offset; PCSel_x<=2;
                          
                                          end
            2'b10:begin prediction_addr<=addr+offset; PCSel_x<=2;
                          
                                          end
            2'b01:begin prediction_addr<=addr+4; PCSel_x<=2;
                          
                                          end
            2'b00:begin prediction_addr<=addr+4; PCSel_x<=2;
                                          end
            endcase
    
              endcase
              end//1101111
            endcase
        end//else if
        else begin //no pre
             PCSel_x<=0;
             clear_reg_x<=0;
             end
  end//always
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  always@(*)begin
  if(clear_reg_clk==1)begin
  clear_reg<=1;
  end
 else if(clear_reg_clk==0||clear_reg_x==0)begin
  clear_reg<=0; 
  end
  end
  
  always@(*)begin
  if(PCSel_clk==1)begin
  PCSel<=1;
  end
  else if(PCSel_clk==3)begin
  PCSel<=3; 
  end
 else if(PCSel_clk==0)begin
  PCSel<=0; 
  end
  else if(PCSel_x==2)
  PCSel<=2; 
  else if(PCSel_x==0)begin
  PCSel<=0; 
  end
  end
  
  
  endmodule
