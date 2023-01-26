//  `timescale 1ns / 1ps  
 module tb_pipeline();
    logic clk, reset;
    wire [31:0] ALU_Out;

    pipeline dut(.clk(clk), .reset(reset), .ALU_Out(ALU_Out));
   
    initial
	begin
	clk=1'b1;
    // reset = 1'b1;
	forever #10 clk=~clk;
	end

    initial begin
        reset = 1'b1;
        #clk;
        // @(posedge clk);
        reset = 1'b0;
        // @(posedge clk);
        #clk;
    end
endmodule