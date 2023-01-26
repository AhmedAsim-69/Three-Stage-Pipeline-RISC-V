//  `timescale 1ns / 1ps  
 module tb_csr();

logic clk, reset, intr_exc, reg_rd, reg_wr;
logic [11:0] addr;
logic [31:0] PC, wdata;

logic [31:0] epc_evec;
logic [31:0] csr_rdata;

    csr dut (
    clk, reset,
    PC,
    addr,
    intr_exc,
    wdata,
    reg_wr,
    reg_rd,
    csr_rdata,
    epc_evec
    );

    initial
	begin
	clk=1'b1;
	forever #10 clk=~clk;
	end

    initial begin
        reset = 1'b1;
        PC <= 32'b0;
        intr_exc <= '0;
        reg_wr <= 1'b1;
        reg_rd <= 1'b1;
        wdata <= 32'h1122_3344;

        @(posedge clk);
        reset = 1'b0;
        @(posedge clk);

    
        addr <= 12'h344;
        @(posedge clk);
        addr = 12'h344;
        @(posedge clk);
        addr = 12'h304; 
        @(posedge clk);
        addr = 12'h300;
        @(posedge clk);
        addr = 12'h342;
        @(posedge clk);
        addr = 12'h305;
        @(posedge clk);
        addr = 12'h341;
        @(posedge clk);

        $stop;
        
    
    end
endmodule