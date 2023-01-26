module pipeline(clk, reset, ALU_Out);

input logic clk, reset;
output logic [31:0] ALU_Out;

logic reg_wr, rd_en, sel_A, sel_B, wr_en;
logic csr_reg_wr, csr_reg_rd, is_mret, intr_exc;
logic [1:0] wb_sel;
logic [3:0] ALU_Sel;
logic [31:0] inst_machine_code, IF_IR;

datapath    dp      (clk, reset, IF_IR, reg_wr, sel_A, sel_B, wb_sel, wr_en, rd_en, ALU_Sel, inst_machine_code, ALU_Out, csr_reg_wr, csr_reg_rd, is_mret, intr_exc);
Controller  ctrlr   (IF_IR, reg_wr, ALU_Sel, rd_en, sel_A, sel_B, wb_sel, wr_en, csr_reg_wr, csr_reg_rd, is_mret, intr_exc);

endmodule
