// `timescale 1ns/1ps
module datapath (
    clk, reset,
    IF_IR,
    reg_wr, sel_A, 
    sel_B,
    wb_sel, wr_en, rd_en,
    ALU_Sel,
    inst_machine_code, ALU_Out, 
    csr_reg_wr,	csr_reg_rd, is_mret, intr_exc
);
    input clk, reset;
    input reg_wr, sel_A, sel_B, wr_en, rd_en, csr_reg_wr, csr_reg_rd, is_mret, intr_exc;
    input [1:0] wb_sel;
    input [3:0] ALU_Sel;
    output logic [31:0] inst_machine_code, ALU_Out, IF_IR;

    logic br_taken;
    logic [2:0] func3;
    logic [4:0] radd1, radd2, write_add;
    logic [6:0] opcode;
    logic [11:0] imm;
    logic [19:0] imm2;
    logic [31:0] rout1, rout2;
    logic [31:0] PC, sign_extend_out, r_data, data_mem_mux_out, imm_mux_out_A, imm_mux_out_B, sseg;

    //Pipeline
    logic stall, stall_MW, flush, reg_wrMW, wr_enMW, rd_enMW, forA, forB, csr_reg_wr_MW, csr_reg_rd_MW, is_mretMW, is_mret, epc_taken;
    logic [1:0] wb_selMW;
    logic [31:0] IF_PC, EX_PC, EX_ALU, EX_WD, EX_Data, EX_Addr, EX_IR;
    logic [31:0] out_data_haz_A, out_data_haz_B;
    logic [31:0] csr_rdata, epc_evec;

    Program_Counter inst_PC (clk, reset, stall, br_taken, epc_taken, opcode, ALU_Out, epc_evec, PC);
    ins_mem InstructionsMemory (PC, inst_machine_code);
    
    //Pipeline
    Pipeline_Reg_NFlush inst_IF_PC(clk, reset, stall, PC, IF_PC);
    Pipeline_Reg inst_IF_IR(clk, reset, stall, flush, inst_machine_code, IF_IR);


    assign func3 = IF_IR[14:12];
    assign radd1 = IF_IR[19:15];
    assign radd2 = IF_IR[24:20];
    assign opcode = IF_IR[6:0];
    assign write_add = EX_IR[11:7];
    assign imm = IF_IR [31:20];
    assign imm2 = IF_IR [31:12];

    
    reg_file RegisterFile (clk, reset, radd1, radd2, write_add, reg_wrMW, data_mem_mux_out, rout1, rout2);

    //Data Hazard
    mux2x1 DataHazardA (forA, rout1, EX_ALU, out_data_haz_A);
    mux2x1 DataHazardB (forB, rout2, EX_ALU, out_data_haz_B);
    forward_unit inst_forward_unit (clk, EX_IR, IF_IR, reg_wrMW, br_taken, wb_selMW, forA, forB, stall, stall_MW, flush);
    
    sign_extend SIGN_EXTENDER(imm, imm2, opcode, IF_IR, sign_extend_out);

    mux2x1 MUX_IMM_sel_A (sel_A, out_data_haz_A, IF_PC, imm_mux_out_A);
    
    mux2x1 MUX_IMM_SEL_B (sel_B, out_data_haz_B, sign_extend_out, imm_mux_out_B);

    branch_cond BRANCH (out_data_haz_A, out_data_haz_B, func3, br_taken, opcode);
    alu ArithmeticLogicUnit(imm_mux_out_A, imm_mux_out_B, ALU_Sel, ALU_Out);

    //Pipeline
    ControllerPipeline inst_ControllerPipeline(clk, reset, reg_wr, wr_en, rd_en, wb_sel, csr_reg_wr, csr_reg_rd, is_mret,
    stall_MW, reg_wrMW, wr_enMW, rd_enMW, wb_selMW, csr_reg_wr_MW, csr_reg_rd_MW, is_mretMW);
    
    Pipeline_Reg_NFlush inst_EX_PC(clk, reset, stall, IF_PC, EX_PC);
    Pipeline_Reg_NFlush inst_EX_IR(clk, reset, stall, IF_IR, EX_IR);
    Pipeline_Reg_NFlush inst_EX_ALU (clk, reset, stall, ALU_Out, EX_ALU);
    Pipeline_Reg_NFlush inst_EX_WD (clk, reset, stall, out_data_haz_B, EX_WD);
    Pipeline_Reg_NFlush inst_CSR_ADDR( clk, reset, stall, sign_extend_out, EX_Addr );
    Pipeline_Reg_NFlush inst_CSR_WDATA( clk, reset, stall, out_data_haz_A, EX_Data );

    csr CSRRW(clk, reset, EX_PC, EX_Addr[11:0], intr_exc, EX_Data, csr_reg_wr_MW, csr_reg_rd_MW, csr_rdata, epc_evec, is_mretMW, epc_taken);

    data_memory DATA_MEM (EX_ALU, EX_WD, wr_enMW, rd_enMW, clk, func3, opcode, r_data, sseg);
    mux4x1 MUX_DATA_SEL (wb_selMW, EX_PC + 4, EX_ALU, r_data, csr_rdata, data_mem_mux_out);

endmodule
