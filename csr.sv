module csr (
    clk, reset,
    PC,
    addr,
    intr_exc,
    wdata,
    reg_wr,
    reg_rd,
    csr_rdata,
    epc_evec, is_mret, epc_taken
    );

    // register file instantiation
    // logic [31:0] csr [0:31];

input clk, reset, intr_exc, reg_rd, reg_wr, is_mret;
input [11:0] addr;
input [31:0] PC;
input [31:0] wdata;

output logic epc_taken;
output logic [31:0] epc_evec;
output logic [31:0] csr_rdata;

logic MIP_and_MIE;

logic csr_mip_wr_flag, csr_mie_wr_flag, csr_mstatus_wr_flag, csr_mcause_wr_flag, csr_mtvec_wr_flag, csr_mepc_wr_flag;

logic [11:0] CSR_ADDR_MIP = 12'h344, CSR_ADDR_MIE = 12'h304, CSR_ADDR_MSTATUS = 12'h300, CSR_ADDR_MCAUSE = 12'h342, CSR_ADDR_MTVEC = 12'h305, CSR_ADDR_MEPC = 12'h341;

logic [31:0] csr_mip_ff, csr_mstatus_ff = 32'h10, csr_mie_ff, csr_mcause_ff = 10'h4, csr_mtvec_ff, csr_mepc_ff;

logic [31:0] csr_add_calc;

// initial begin
//         // Reading the contents of imem.txt file to memory variable
//         $readmemh( "D:/UNIVERSITY Stuff/SEMESTER 7/Computer Architecture - Lab/Week 15/Simulations/csr.txt", csr);
//     end

//MIP = 32'b0000000000000000                    0000  0     0   0     0    0    0  0    0    0    0  0     0
//MIP = 32'CustomPlatformSpecificInterrupts      R   MEIP   R   SEIP  UEIP MTIP R STIP UTIP  MSIP R SSIP  USIP

// assign csr_mip_ff = 32'b0000000000000000_0000_1_0_001_0_001_000;
// assign csr_mip_ff = 32'b00000000000000000000100010001000;

logic MEPFF_PC_SIG;

always_comb begin
    csr_rdata <= 'b0;

    if (reg_rd) begin
        case (addr)
            CSR_ADDR_MIP: csr_rdata <= csr_mip_ff;
            CSR_ADDR_MIE: csr_rdata <= csr_mie_ff;
            CSR_ADDR_MSTATUS: csr_rdata <= csr_mstatus_ff;
            CSR_ADDR_MCAUSE: csr_rdata <= csr_mcause_ff; 
            CSR_ADDR_MTVEC: csr_rdata <= csr_mtvec_ff;
            CSR_ADDR_MEPC: csr_rdata <= csr_mepc_ff; 
        endcase        
    end
    
end

always_comb begin

    csr_mip_wr_flag = 1'b0;
    csr_mie_wr_flag = 1'b0;
    csr_mstatus_wr_flag = 1'b0;
    csr_mcause_wr_flag = 1'b0;
    csr_mtvec_wr_flag = 1'b0;
    csr_mepc_wr_flag = 1'b0;

    if (reg_wr) begin    
        case (addr)
            CSR_ADDR_MIP: csr_mip_wr_flag = 1'b1;
            CSR_ADDR_MIE: csr_mie_wr_flag = 1'b1;
            CSR_ADDR_MSTATUS: csr_mstatus_wr_flag = 1'b1;
            CSR_ADDR_MCAUSE: csr_mcause_wr_flag = 1'b1; 
            CSR_ADDR_MTVEC: csr_mtvec_wr_flag = 1'b1;
            CSR_ADDR_MEPC: csr_mepc_wr_flag = 1'b1;
        endcase // exu2csr_data.csr_addr
    end // exe2csr_ctrl.csr_wr_req
    
end

// Update the mip (machine interrupt pending) CSR
always_ff @(posedge reset, posedge clk) begin
    epc_taken <= 0;
    // csr_mip_ff <= 32'b0000000000000000_0000_1_0_001_0_001_000;
    // csr_mip_ff <= 0;
    // csr_mstatus_ff <= 0;
    // csr_mie_ff <= 0;
    // csr_mcause_ff <= 0;
    // csr_mtvec_ff <= 0;
    // csr_mepc_ff <= 0;
    
    if (reset) begin
        csr_mip_ff <= 32'b0;
    end 
    // else if (timer_interrupt) begin
    else if (intr_exc) begin
        csr_mip_ff[7] <= 1;
    end

    MIP_and_MIE <= csr_mip_ff[7] & csr_mie_ff[7];
    MEPFF_PC_SIG <= MIP_and_MIE & csr_mstatus_ff[4];

    if( MEPFF_PC_SIG ) begin
        csr_mepc_ff <= PC;
        epc_taken <= 1;
    end
end

    mux2x1 CSR_ADDR_MUX (csr_mtvec_ff[0], {csr_mtvec_ff[31:2], 2'b00}, ( csr_mtvec_ff[31:2] + csr_mcause_ff << 2 ), csr_add_calc);
    mux2x1 CSR_EPCEVEC_MUX (is_mret, csr_add_calc, csr_mepc_ff, epc_evec);

// Update the mtvec CSR
always_ff @(posedge reset, posedge clk) begin
    if (reset) begin
        csr_mtvec_ff <= 32'b0;
    end 
    else if (csr_mtvec_wr_flag) begin
        csr_mtvec_ff <= wdata;
    end
    else if (csr_mip_wr_flag) begin
        csr_mip_ff <= wdata;
    end
    else if (csr_mie_wr_flag) begin
        csr_mie_ff <= wdata;
    end
    else if (csr_mepc_wr_flag) begin
        csr_mepc_ff <= wdata;
    end
    else if (csr_mcause_wr_flag) begin
        csr_mcause_ff <= wdata;
    end
    else if (csr_mstatus_wr_flag) begin
        csr_mstatus_ff <= wdata;
    end
end

endmodule