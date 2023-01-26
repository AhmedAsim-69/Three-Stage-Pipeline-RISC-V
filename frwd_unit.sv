module forward_unit (
    clk,
    oldIR, newIR, reg_wrMW, br_taken, wb_selMW,
    forA, forB, stall, stall_MW, flush
    );

input clk;
input reg_wrMW, br_taken;
input [1:0] wb_selMW;
input [31:0] oldIR, newIR;
output logic forA, forB, stall, stall_MW, flush;
logic [4:0] oldRD;
logic [4:0] newRS1, newRS2;
always_ff @ (posedge clk) begin 
    stall <= 0; 
    stall_MW <= 0;
    forA <= 0;
    forB <= 0;


    oldRD <= oldIR[11:7];
    newRS1 <= newIR[19:15];
    newRS2 <= newIR[24:20];

    if( (oldIR[11:7] == newIR[19:15]) & (reg_wrMW == 1) ) begin                     // FORWARD A
        forA <= 1;
    end

    if( (oldIR[11:7] == newIR[24:20]) & (reg_wrMW == 1) ) begin                     // FORWARD B
        forB <= 1;
    end


    if( ( (oldIR[11:7] == newIR[19:15]) | (oldIR[11:7] == newIR[24:20]) )           // STALL
     & (reg_wrMW == 1) 
     & (wb_selMW == 2'b01) ) begin
        stall <= 1;
        stall_MW <= 1;
     end
end
always_comb begin
    case (br_taken)
        1'b1: flush <= 1; 
        default: flush <= 0;
     endcase    
end


endmodule

