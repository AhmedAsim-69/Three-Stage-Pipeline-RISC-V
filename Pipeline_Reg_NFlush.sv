module Pipeline_Reg_NFlush(
            clk, reset, stall,
            newContent, outContent
            );

	input reset, clk, stall;
	input [31:0] newContent;
	output logic [31:0] outContent;
    
	always_ff @(posedge clk) begin
		if(reset)
			outContent <= 32'b0;
		else if (!stall | stall ==='x | stall ==='z)
			outContent <= newContent;
	end
	
endmodule