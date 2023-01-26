module sign_extend(
    input [11:0] x,
    input [19:0] x2,
    input [6:0] ins_type,
    input [31:0] instruction,
    output logic [31:0] y
    );
    always_comb begin 
        case (ins_type)
            7'b0010011, 7'b1100111: y <= {{20{x[11]}}, x};      //I-Type, JALR
            7'b0110111, 7'b0010111: y <= {x2, {12{1'b0}}};      //U-Type (LUI), AUIPC
            7'b0000011: y <= {{20{1'b0}}, x};                   //Load
            7'b0100011: y <= {{20{1'b0}},instruction[31:25],instruction[11:7]};                                         //S Type
            7'b1100011: y <= {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};      // B-Type
            7'b1101111: y <= {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};    // JAL
            7'b1110011: y <= {{20{1'b0}}, instruction[31:20]};  //CSRRW
        endcase
        
    end
   
endmodule