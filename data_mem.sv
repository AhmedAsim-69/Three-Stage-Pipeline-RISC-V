module data_memory#(parameter size =32)
(
    input[size-1:0]addr, wdata,
    input wr_en, rd_en, clk,
    input [2:0] func3,
    input [6:0] opcode,
    output logic [size -1:0] r_data, sseg
);
    
    logic [31:0] data_mem [0:31];
    
    initial begin
        $readmemh("D:/UNIVERSITY Stuff/SEMESTER 7/Computer Architecture - Lab/Week 15/Simulations/data_mem.txt", data_mem);
    end
    
    always_ff @(posedge clk) begin
        sseg <= data_mem[0];
        if (wr_en) begin
        case (func3)
            000 : data_mem[addr] <= {{24{1'b0}}, wdata[7:0]};                      //SB
            001 : data_mem[addr] <= {{16{1'b0}}, wdata[15:0]};                     //SH
            010 : data_mem[addr] <= wdata;                                         //SW
            default: data_mem[addr] <= wdata; 
        endcase
        end
    end

    always_comb begin 
        r_data <= 'x;
        if (rd_en) begin
        case (func3)
            000 : r_data <= {{24{data_mem[addr][7]}}, (data_mem[addr][7:0])};    //LB
            001 : r_data <= {{16{data_mem[addr][15]}}, (data_mem[addr][15:0])};  //LH
            010 : r_data <= (data_mem[addr][31:0]);                              //LW
            100 : r_data <= {{24{1'b0}}, (data_mem[addr][7:0])};                 //LBU
            101 : r_data <= {{16{1'b0}}, (data_mem[addr][15:0])};                //LHU
            default: r_data <= (data_mem[addr]); 
        endcase
        end

    end
//--------------------------------- LAB 10 ---------------------------------//
logic dmem_sel, uart_sel;

assign dmem_sel = ( opcode == 7'b0000011 | opcode == 7'b0100011 | opcode == 7'b0110111 ) && (addr[31:28] == 4'h0);
assign uart_sel = ( opcode == 7'b0000011 | opcode == 7'b0100011 | opcode == 7'b0110111 ) && (addr[31:28] == 4'h8);




//--------------------------------- LAB 11 ---------------------------------//
// output logic sseg [31:0];


endmodule
