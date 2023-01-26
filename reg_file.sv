module reg_file (
    clk, rst_n,
    radd1,
    radd2,
    write_add,
    reg_wr,
    write_data,
    rout1,
    rout2
);

    // register file instantiation
input reg_wr;
input clk, rst_n;
input [4:0] radd1;
input [4:0] radd2;
input [4:0] write_add;
input [31:0] write_data;
output logic [31:0] rout1;
output logic [31:0] rout2;

logic rf_wr_valid;
logic rsl_addr_valid;
logic rs2_addr_valid;

logic [31:0] register_file [0:31];

initial begin
        // Reading the contents of imem.txt file to memory variable
        $readmemh( "D:/UNIVERSITY Stuff/SEMESTER 7/Computer Architecture - Lab/Week 15/Simulations/reg_file.txt", register_file);
    end

// control signals for validity of register file read/write operations
// assign rsl_addr_valid =| radd1;
// assign rs2_addr_valid =| radd2;

assign rsl_addr_valid = ((radd1 === 'x) | (radd1 === 'z))? 1'b0 : 1'b1;
assign rs2_addr_valid = ((radd2 === 'x) | (radd2 === 'z))? 1'b0 : 1'b1;

assign rf_wr_valid = ((write_add & reg_wr === 'x) | (write_add & reg_wr ===  'z)) ? 1'b0 : 1'b1;

// asynchronous read operation for two register operands
assign rout1 = (rsl_addr_valid) ? register_file[radd1] : '0;
assign rout2 = (rs2_addr_valid) ? register_file[radd2] : '0;

// assign rout1 = register_file[radd1];
// assign rout2 = register_file[radd2];


always_ff @( negedge clk ) begin
    if (reg_wr) begin
        register_file[write_add] <= write_data;    
    end
    
end

endmodule