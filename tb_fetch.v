//======================================================
// Testbench: Instruction Fetch (PC + Instruction Memory)
//======================================================

`timescale 1ns/1ps
module tb_fetch;

    reg clk;
    reg reset;
    wire [31:0] pc_out;
    wire [31:0] instr;

    // Next PC logic (for now, just PC+4)
    wire [31:0] next_pc;
    assign next_pc = pc_out + 4;

    // Instantiate Program Counter
    pc pc_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc_out(pc_out)
    );

    // Instantiate Instruction Memory
    instr_mem imem_inst (
        .addr(pc_out),
        .instr(instr)
    );

    // Clock generator (10ns period)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_fetch.vcd");
        $dumpvars(0, tb_fetch);

        // Init
        clk = 0; reset = 1;
        #10 reset = 0;

        // Run for a few cycles
        #50;

        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time=%0t | PC=%h | INSTR=%h", $time, pc_out, instr);
    end

endmodule