module Pipeline_Reg(
            clk, reset, stall, flush,
            new_content, out_content
            );

	input reset, clk, stall, flush;
	input [31:0] new_content;
	output logic [31:0] out_content;
    
	always_ff @(posedge clk) begin
		if(reset | flush)
			out_content <= 32'b0;
		else if (!stall | stall ==='x | stall ==='z)
			out_content <= new_content;
	end
	
endmodule