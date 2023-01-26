module ControllerPipeline(
	clk, reset,
	reg_wr, wr_en, rd_en, wb_sel,
	csr_reg_wr,	csr_reg_rd, is_mret, stall_MW,
	reg_wrMW, wr_enMW, rd_enMW, wb_selMW,
	csr_reg_wr_MW, csr_reg_rd_MW, is_mretMW
	);

input clk, reset, reg_wr, wr_en, rd_en, csr_reg_wr,	csr_reg_rd, is_mret, stall_MW;
input [1:0] wb_sel;
output logic reg_wrMW, wr_enMW, rd_enMW, csr_reg_wr_MW, csr_reg_rd_MW, is_mretMW;
output logic [1:0] wb_selMW;

always_ff @(posedge clk) begin

	if (!stall_MW  | stall_MW ==='x | stall_MW ==='z ) begin
		reg_wrMW <= reg_wr;
		wr_enMW  <= wr_en;
		rd_enMW  <= rd_en;
		wb_selMW <= wb_sel;
		csr_reg_rd_MW  <= csr_reg_rd;
		csr_reg_wr_MW  <= csr_reg_wr;
		is_mretMW <= is_mret;
	end

end

endmodule