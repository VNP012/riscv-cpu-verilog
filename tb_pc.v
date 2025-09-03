//======================================================
// Testbench for Program Counter (PC)
//======================================================

`timescale 1ns/1ps
module tb_pc;

    reg clk;
    reg reset;
    reg [31:0] next_pc;
    wire [31:0] pc_out;

    // Instantiate PC
    pc uut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc_out(pc_out)
    );

    // Clock generator (10ns period)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_pc.vcd");   // for GTKWave
        $dumpvars(0, tb_pc);

        // Init
        clk = 0; reset = 1; next_pc = 0;
        #10 reset = 0;

        // Step through PC values
        next_pc = 32'h00000004; #10;
        next_pc = 32'h00000008; #10;
        next_pc = 32'h0000000C; #10;
        next_pc = 32'h00000010; #10;

        $finish;
    end

endmodule


