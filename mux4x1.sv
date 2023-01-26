module mux4x1 (
    wb_sel,
    PC_4, ALU_Out, r_data, csr_rdata,
    out_data
);
    input [1:0] wb_sel;
    input [31:0] PC_4, ALU_Out, r_data, csr_rdata;
    output logic [31:0] out_data;

    always_comb begin 
        case (wb_sel)
            2'b00 : out_data <= ALU_Out;
            2'b01 : out_data <= r_data;
            2'b10 : out_data <= PC_4;
            2'b11 : out_data <= csr_rdata;
        endcase
    end

endmodule