module mux2x1 (
    sel_sgnl,
    alt_sel, tru_sel,
    out_mux
);
    input sel_sgnl;
    input [31:0] alt_sel, tru_sel;
    output logic [31:0] out_mux;

    always_comb begin 
        if(sel_sgnl) begin
            out_mux <= tru_sel;
        end
        else begin 
            out_mux <= alt_sel;
        end
    end

endmodule