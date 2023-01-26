module alu(
        A, B,             
        ALU_Sel,
        ALU_Out 
        );
    input [31:0] A,B;             
    input [3:0] ALU_Sel;
    output logic [31:0] ALU_Out;
    always_comb 
    begin
        case(ALU_Sel)
            4'b0000 : ALU_Out = A + B;                                          //Addition 
            4'b1000 : ALU_Out = A + (~B) + 1'b1;                                //SUB      
            4'b0111 : ALU_Out = A & B;                                          //Logical AND
            4'b0110 : ALU_Out = A | B;                                          //OR
            4'b0100 :  ALU_Out = A^B;                                           //XOR
            4'b0011 : ALU_Out = (A < B)? 32'd1 : 32'd0;                         //SLTU
            4'b0010 : ALU_Out = ($signed(A) < $signed(B))? 32'd1 : 32'd0;       //SLT
            4'b0101 : ALU_Out = A >> B[4:0];                                    //SRL
            4'b1101 : ALU_Out = A >>> B[4:0];                                   //SRA
            4'b0001 : ALU_Out = A << B[4:0];                                    //SLL		
            4'b1111 : ALU_Out = B;                                              //LUI
            default: ALU_Out = 0; 
        endcase
    end

endmodule