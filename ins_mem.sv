module ins_mem (
    address,
    inst_machine_code
);
    input [31:0] address;
    output logic [31:0] inst_machine_code;

    logic [7:0] inst_memory [0:127];    //Byte-Accessible
    // logic [31:0] inst_memory [0:31];    //Word Addressable 

    initial begin
            // Reading the contents of imem.txt file to memory variable
            $readmemh( "D:/UNIVERSITY Stuff/SEMESTER 7/Computer Architecture - Lab/Week 15/Simulations/imem.txt", inst_memory);


        end
    always_comb begin
        //  Word addressable
        // inst_machine_code <= inst_memory[address];

        //Byte accessible
         inst_machine_code = {inst_memory[address],inst_memory[address+1],inst_memory[address+2],inst_memory[address+3]};
    end
    
endmodule