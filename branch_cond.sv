module branch_cond (
    rout1, rout2, alu_op, br_taken, opcode
    );

input [2:0] alu_op;
input [6:0] opcode;
input [31:0] rout1, rout2;
output logic br_taken;

always_comb begin 
    case (opcode)
        7'b1100011: begin
            case (alu_op)
                3'b000: begin //BEQ
                    br_taken <= (rout1 == rout2) ? 1'b1 : 1'b0;
                end 
                3'b001: begin //BNE
                    br_taken <= (rout1 != rout2) ? 1'b1 : 1'b0;
                end 
                3'b100: begin //BLT
                    br_taken <= ($signed(rout1) < $signed(rout2)) ? 1'b1 : 1'b0;
                end 
                3'b101: begin // BGE
                    br_taken <= ($signed(rout1) >= $signed(rout2)) ? 1'b1 : 1'b0;
                end 
                3'b110: begin //BLTU
                    br_taken <= (rout1 < rout2) ? 1'b1 : 1'b0;
                end 
                3'b111: begin //BGEU
                    br_taken <= (rout1 >= rout2) ? 1'b1 : 1'b0;
                end 
                default: br_taken <= 0;
            endcase
        end
        7'b1101111: br_taken <= 1;  //JAL
        7'b1100111: br_taken <= 1;  //JAL-R
        default: br_taken <= 0;
    endcase
end


endmodule

