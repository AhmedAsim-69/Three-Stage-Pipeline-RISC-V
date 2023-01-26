module Program_Counter(
    clk, reset, stall,
    br_taken, epc_taken, opcode,
    ALU_Out, epc_evec,
    PC
);
input clk, reset, stall;
input br_taken, epc_taken;
input [6:0] opcode;
input [31:0] ALU_Out, epc_evec;
output logic [31:0] PC;

// logic [31:0] br;

//     always_ff @( posedge clk ) begin
//         if (reset) PC <= 0;
//         else if ((opcode == 7'b1100111) | (opcode == 7'b1101111)) PC <= ALU_Out;
//     end

// mux2x1 PCbranch (br_taken, PC + 1, ALU_Out, br);

// mux2x1 PCsel (epc_taken, PC + 1, epc_evec, PC);

always_ff @( posedge clk ) begin
        // stall <= 0;
        if(reset) PC <= 0;
        else if(!stall | stall ==='x | stall ==='z ) begin
            if (br_taken) PC <= ALU_Out;
            else if ((opcode == 7'b1100111) | (opcode == 7'b1101111)) PC <= ALU_Out;
            else if (epc_taken) PC <= epc_evec;
            else PC <= PC + 4;
        end
    end

endmodule