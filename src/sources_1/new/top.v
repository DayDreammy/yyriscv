`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/02 15:40:40
// Design Name: 
// Module Name: top
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
/* riscv top */
`include "define.v"

module top(
    input wire clk,
    input wire rst,
    output wire [`reg_bus] wb_data_o,
    output wire sel1
    );
    
    // pc_reg output
	wire [`inst_addr_bus] pc_pc_o;
	
	// imem output
	wire [`inst_bus] imem_inst_i;
	
	//decode riscv ctr output
	wire de_RegWen;
	wire [`reg_addr_bus] de_raddrB_o;
    wire [`reg_addr_bus] de_raddrA_o;
    wire [`reg_addr_bus] de_waddr_o;
    wire de_ASel;
    wire de_BSel;
    wire [`immsel_bus] de_Immsel;
    wire [`alusel_bus] de_ALUsel;
    wire [`wbsel_bus] de_WBSel;
    wire de_MemRW;
    wire de_jalr_or_jal; // pipeline mode ,decode stage just judge jual or jalr
    wire de_BrUn;
    
    // regs output
    wire [`reg_bus]  regs_rdataA_o;
    wire [`reg_bus]  regs_rdataB_o;
    
    //imm_Gen output
    wire [`imm_bus] imm_imm_o;
    
    //alu output
    wire [`reg_bus] alu_mem_wdata_o;
    assign mem_wrb_data=alu_mem_wdata_o;
    
    // dmem output
	wire [`data_bus] dmem_data_o;
	
	//bus output
	wire [`reg_bus] bus_data_i;
    wire [`reg_bus] bus_addr_i;
    wire [`reg_bus] bus_inst_i;
    wire bus_MemRW;
    wire [`reg_bus] bus_data_o;
	
	// Branch Comparator output
	wire  br_pcsel;
	

	// reg_if_id output
	wire [`inst_addr_bus] id_pc_o;
    wire [`inst_bus] id_inst_o;
    //reg id_ex output
    wire [`inst_addr_bus] ex_pc_o;
    wire [`reg_bus]  ex_opv1_o;
    wire [`reg_bus]  ex_opv2_o;
    wire [`imm_bus]  ex_inst_o;
    wire [`immsel_bus] ex_Immsel_o;//ctrl
    wire ex_RegWen_o;
    wire ex_BrUn_o;
    wire ex_ASel_o;
    wire ex_BSel_o;
    wire [`alusel_bus] ex_ALUsel_o;
    wire ex_MemRW_o;
    wire [`wbsel_bus] ex_WBSel_o;
    //reg ex_mem output
    wire [`inst_addr_bus] mem_pc_o;
    wire [`reg_bus] mem_aluop_o;
    wire [`reg_bus] mem_mem_datao;
    wire [`inst_bus] mem_inst_o;
    wire mem_MemRW_o;
    wire [`wbsel_bus] mem_WBSel_o;
    wire mem_RegWen_o;
    //reg mem_wb output
    wire [`reg_addr_bus] wb_regw_addr_o;
    wire [`reg_bus] wb_regw_data_o;
    assign wb_data_o=wb_regw_data_o;
    wire wb_RegWen_o;
    wire [`reg_bus] wb_data31_o;
    
    //forwarding ctrl
    wire [`reg_bus] forw_dataA_o;
    wire [`reg_bus] forw_dataB_o;
    // pipelineed reg output
	wire [`stall_bus] stall;
	
	// branch prediction
	wire  [`inst_addr_bus] pre_addr_o;
	wire pre_clear_reg_o;
    wire[`pcsel_bus] pre_PCSel_o;
  
    // pc_reg module instances
    pc_reg u_pc_reg(
        .clk    (     clk),
        .rst    (     rst),
        .PCSel  (     pre_PCSel_o),
        .stall  (     stall),
        .br_addr_i    (alu_mem_wdata_o),
        
        //pre_dic
         .pre_addr_i (  pre_addr_o),
         .pc_ex_i  (   mem_pc_o),
        
        .pc_o   (     pc_pc_o)

    );
    
    // imem module instances
    imem u_imem(
        .clk         (clk),
        .inst_addr    (     pc_pc_o),
        .inst_i       (   imem_inst_i)
        
    );
    
     // pipelineed reg_if_id instances
     reg_if_id u_reg_if_id(
        .clk        (   clk),
        .rst        (   rst),
        .pc_i       (   pc_pc_o),
        .br       (   pre_clear_reg_o),//branch
        .stall      (   stall),
        .inst_i     (   imem_inst_i),
        .id_pc_o    (   id_pc_o),
        .id_inst_o  (   id_inst_o)

    );
    
    // decode riscv module instances
    riscv u_dc_riscv(
        .inst_i      (   id_inst_o),
        .BrEQ        (   brc_BrEQ),
        .BrLT        (   brc_BrLT),
        .jalr_or_jal (   de_jalr_or_jal),
        .Immsel      (   de_Immsel),
        .BrUn        (   de_BrUn),
        .ASel        (   de_ASel),
        .BSel        (   de_BSel),
        .ALUsel      (   de_ALUsel),
        .MemRW       (   de_MemRW),
        .RegWen      (   de_RegWen),
        .WBSel       (   de_WBSel),
        .raddrB_o    (   de_raddrB_o),
        .raddrA_o    (   de_raddrA_o),
        .waddr_o     (   de_waddr_o)

    );

    // regs module instances
    gprs u_gprs(
        .clk         (  clk),
        .RegWen      (  wb_RegWen_o),

        .raddrA_i    (   de_raddrA_o),
        .raddrB_i    (   de_raddrB_o),
        .waddrD_i    (   wb_regw_addr_o),
        .wdataD_i    (   wb_regw_data_o),
        .rdataA_o    (   regs_rdataA_o),
        .rdataB_o    (   regs_rdataB_o)
        
    );
    
    // pipelineed reg_id_ex instances
     reg_id_ex u_reg_id_ex(
        .clk        (   clk),
        .rst        (   rst),
        .stall      (   stall),
        .id_pc_i    (   id_pc_o),
        .br       (   pre_clear_reg_o),//branch
        
        .id_opv1_i  (   forw_dataA_o),
        .id_opv2_i  (   forw_dataB_o),
        .id_inst_i  (   id_inst_o),
        .id_Immsel_i(   de_Immsel),//ctrl
        .id_RegWen_i(   de_RegWen),
        .id_BrUn_i  (   de_BrUn),
        .id_ASel_i  (   de_ASel),
        .id_BSel_i  (   de_BSel),
        .id_ALUsel_i(   de_ALUsel),
        .id_MemRW_i (   de_MemRW),
        .id_WBSel_i (   de_WBSel),
        
        .ex_pc_o    (   ex_pc_o),
        .ex_opv1_o  (   ex_opv1_o),
        .ex_opv2_o  (   ex_opv2_o),
        .ex_inst_o  (   ex_inst_o),
        .ex_Immsel_o(   ex_Immsel_o),//ctrl
        .ex_RegWen_o(   ex_RegWen_o),
        .ex_BrUn_o  (   ex_BrUn_o),
        .ex_ASel_o  (   ex_ASel_o),
        .ex_BSel_o  (   ex_BSel_o),
        .ex_ALUsel_o(   ex_ALUsel_o),
        .ex_MemRW_o (   ex_MemRW_o),
        .ex_WBSel_o (   ex_WBSel_o)     

    );
    
    // imm_Gen module
    imm_Gen u_imm_Gen(
        .inst_i     (ex_inst_o ),
        .Immsel_i   (ex_Immsel_o   ),
        .imm_o      (imm_imm_o   )
    );
    
    // alu module instances
    alu u_alu(
         .ALUsel      (   ex_ALUsel_o),
         .ASel        (   ex_ASel_o),
         .BSel        (   ex_BSel_o),
         .rs1_i       (   ex_opv1_o),
         .rs2_i       (   ex_opv2_o),
         .pc_i        (   ex_pc_o),
         .imm_i       (   imm_imm_o),
         .mem_wdata_o (   alu_mem_wdata_o)

    );
    
     // pipelineed reg_ex_mem instances
     reg_ex_mem u_reg_ex_mem(
        .clk          (   clk),
        .rst          (   rst),
        .stall        (   stall),
        .ex_pc_i      (   ex_pc_o),
        .ex_aluop_i   (   alu_mem_wdata_o),
        .ex_mem_datai (   ex_opv2_o),
        .ex_inst_i    (   ex_inst_o),
        .ex_MemRW_i   (   ex_MemRW_o),//ctrl
        .ex_WBSel_i   (   ex_WBSel_o),
        .ex_RegWen_i  (   ex_RegWen_o),
          
        .mem_pc_o     (   mem_pc_o),
        .mem_aluop_o  (   mem_aluop_o),
        .mem_mem_datao(   mem_mem_datao),
        .mem_inst_o   (   mem_inst_o),
        .mem_MemRW_o  (   mem_MemRW_o),//ctrl
        .mem_WBSel_o  (   mem_WBSel_o),
        .mem_RegWen_o (   mem_RegWen_o),
        .Req          (   Req)

    );
    
     // dmem module instances
    dmem u_dmem(
        .clk          (   clk),
        .MemRW        (   bus_MemRW),
        .data_addr    (   bus_addr_i),
        .inst_i       (   bus_inst_i),
        .dataw_i      (   bus_data_i),
        .datar_o      (   bus_data_o)

    );   
    
    // pipelineed reg_mem_wb instances
     reg_mem_wb u_reg_mem_wb(
        .clk            (   clk),
        .rst            (   rst),
        .stall          (   stall),
        .mem_aluop_i    (   mem_aluop_o),
        .mem_WBSel_i    (   mem_WBSel_o),
        .mem_RegWen_i   (   mem_RegWen_o),
        .mem_pc_i       (   mem_pc_o),
        .mem_regw_addr_i(   mem_inst_o),
        .mem_regw_data_i(   dmem_data_o),
        .wb_regw_addr_o (   wb_regw_addr_o),
        .wb_regw_data_o (   wb_regw_data_o),
        .wb_RegWen_o    (   wb_RegWen_o),
        
        .wb_data31_o    (   wb_data31_o)
        
    );
    
     // Branch Comparator module instances
    Branch_Comp u_brc(
        .bra_dataA_i    (   ex_opv1_o),
        .bra_dataB_i    (   ex_opv2_o),
        .BrUn           (   ex_BrUn_o),
        .inst_i         (   ex_inst_o),
        .PCSel          (   br_pcsel)

    );
    
    // forwarding ctrl module instances
    forw_ctrl u_forw_ctrl(
        .rst               (   rst),
        .forw_id_inst_i    (   id_inst_o),
        .forw_ex_inst_i    (   ex_inst_o),
        .forw_ex_RegWen_i  (   ex_RegWen_o),
        .forw_ex_WBSel_i   (   ex_WBSel_o),
        .forw_mem_inst_i   (   mem_inst_o),
        .forw_mem_RegWen_i (   mem_RegWen_o),
        .forw_mem_WBSel_i  (   mem_WBSel_o),
        
        //input regd
         .reg_dataA_i  (   regs_rdataA_o),
         .reg_dataB_i  (   regs_rdataB_o),
         
         //input forwi data
         .ex_alu_i    (  alu_mem_wdata_o),
         .mem_31sel_i (   wb_data31_o),
         
         //output forwo data
         .forw_dataA_o  (   forw_dataA_o),
         .forw_dataB_o  (   forw_dataB_o),
         
         //input decode jal/jalr
          .de_jal_jalr_i(   de_jalr_or_jal),
         
         //stall
         .stall         (   stall)
    );
    
    Bus Bus(
        .Req         (   Req),
        .Wdata       (   mem_mem_datao),
        .Addr        (   mem_aluop_o), 
        .WREN        (   mem_MemRW_o), 
        .Instr       (   mem_inst_o), 
        .Rdata       (   dmem_data_o), 
        .slave_Wdata (   bus_data_i), 
        .slave_Addr  (   bus_addr_i), 
        .slave_Instr (   bus_inst_i), 
        .Wen         (   bus_MemRW), 
        .slave1_Rdata(   bus_data_o), 
        .sel1        (   sel1)
    
    );
    
    //  branch prediction
    branchpre u_branchpre(
        .clk         (   clk),
        .rst         (   rst),
        .inst_if_i   (   imem_inst_i),
        .inst_3      (   ex_inst_o),
        .addr        (   pc_pc_o ),
        .real_addr   (   ex_pc_o),
        .branch_comparation( br_pcsel),
        //output
        .prediction_addr   (   pre_addr_o),
        .clear_reg         (   pre_clear_reg_o),
        .PCSel             (   pre_PCSel_o)

    );
    
	
    
endmodule
