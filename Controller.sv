module Controller(
	IF_IR, reg_wr, ALU_Sel,
	rd_en, 
	sel_A, sel_B, wb_sel, wr_en,
	csr_reg_wr, csr_reg_rd, is_mret, intr_exc
	);

input logic [31:0] IF_IR;
output logic reg_wr, rd_en, sel_A, sel_B, wr_en;
output logic csr_reg_wr, csr_reg_rd, is_mret, intr_exc;
output logic [1:0]  wb_sel;
output logic [3:0] ALU_Sel;

// 00110000001000000000000001110011 is_mret

always_comb begin
	csr_reg_wr <= 0; 
	csr_reg_rd <= 0;
	is_mret <= 0;
	intr_exc <= 0;
	case(IF_IR[6:0]) 
		7'b0110011: begin	//R-TYPE
			if (IF_IR[14:12] == 3'b000) begin
				if(IF_IR[31:25] == 7'b0100000)  ALU_Sel <= 4'b1000;
				else  ALU_Sel <= 4'b0000;
				end
			else if(IF_IR[14:12] == 3'b101) begin
				if(IF_IR[31:25] == 7'b0100000)  ALU_Sel <= 4'b1101;
				else  ALU_Sel <= 4'b0101;
			end
			else  ALU_Sel <= {1'b0, IF_IR[14:12]};
			end

		7'b0010011: begin	//I-TYPE
			if(IF_IR[14:12] == 3'b101) begin
				if(IF_IR[31:25] == 7'b0100000)  ALU_Sel <= 4'b1101;
				else  ALU_Sel <= 4'b0101;
			end
			else  ALU_Sel <= {1'b0, IF_IR[14:12]};
			end

		7'b0000011, 7'b0010111: begin	//LOAD, AUIPC
			ALU_Sel <= 4'b0000;
			end

		7'b0110111: begin 	//LUI
			ALU_Sel <= 4'b1111;
		end
		
		7'b0100011: begin	//S-TYPE
			ALU_Sel <= 4'b0000;
			end
		7'b1101111: begin	//J-TYPE
			ALU_Sel <= 4'b0000;
			end
			

	endcase

	case (IF_IR[6:0])
		7'b0110011: begin //R-Type
			reg_wr <= 1;
			sel_A <= 0;
			sel_B <= 0;
			rd_en <= 0;
			wb_sel <= 0;
			wr_en <= 0;
			intr_exc <= 1;
		end
		7'b0010011: begin //I-Type
			reg_wr <= 1;
			sel_A <= 0;
			sel_B <= 1;
			rd_en <= 0;
			wb_sel <= 0;
			wr_en <= 0;
		end
		7'b0000011: begin //LOAD
			reg_wr <= 1;
			sel_A <= 0;
			sel_B <= 1;
			rd_en <= 1;
			wb_sel <= 1;
			wr_en <= 0;
		end
		7'b0100011: begin //S-Type
			reg_wr <= 0;
			sel_A <= 0;
			sel_B <= 1;
			wr_en <= 1;
			rd_en <= 0;
			wb_sel <= 'x;
		end
		7'b0110111: begin //U-Type (LUI)
			reg_wr <= 1;
			sel_A <= 0;
			sel_B <= 1;
			wr_en <= 0;
			rd_en <= 0;
			wb_sel <= 0;
		end
		7'b0010111: begin //AUPIC-Type
			reg_wr <= 1;
			sel_A <= 1;
			sel_B <= 1;
			wr_en <= 0;
			rd_en <= 0;
			wb_sel <= 0;
		end
		7'b1100011: begin //B-Type
			reg_wr <= 0;
			sel_A <= 1;
			sel_B <= 1;
			wr_en <= 0;
			rd_en <= 0;
			wb_sel <= 'x;
		end
		7'b1101111: begin //JAL
			reg_wr <= 0;
			sel_A <= 1;
			sel_B <= 1;
			wr_en <= 0;
			rd_en <= 0;
			wb_sel <= 2;
		end
		7'b1100111: begin //JAL-R
			reg_wr <= 1;
			sel_A <= 0;
			sel_B <= 1;
			wr_en <= 0;
			rd_en <= 0;
			wb_sel <= 2;
		end
		7'b1110011: begin //CSRRW
			reg_wr <= 1;
			sel_A <= 0;
			sel_B <= 1;
			rd_en <= 0;
			wb_sel <= 3;
			wr_en <= 0;
			csr_reg_wr <= 1; 
			csr_reg_rd <= 1;
		end
	endcase
		if(IF_IR == 32'b00110000001000000000000001110011) begin
			reg_wr <= 1;
			sel_A <= 0;
			sel_B <= 1;
			rd_en <= 0;
			wb_sel <= 3;
			wr_en <= 0;
			is_mret <= 1;
			// intr_exc <= 1;
		end 

end

endmodule