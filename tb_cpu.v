//======================================================
// Testbench for CPU Top (Single-Cycle RV32I)
//======================================================

`timescale 1ns/1ps
module tb_cpu;

    reg clk, reset;

    // Instantiate CPU with debug outputs
    wire [31:0] alu_result;
    wire        alu_zero;
    wire        branch;
    wire [31:0] imm_out;

    cpu_top uut (
        .clk(clk),
        .reset(reset),
        .alu_result(alu_result),
        .alu_zero(alu_zero),
        .branch(branch),
        .imm_out(imm_out)
    );

    // Clock generator: 10 ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_cpu.vcd");
        $dumpvars(0, tb_cpu);

        // Init
        clk = 0;
        reset = 1;
        #10 reset = 0;

        // Run for a while
        #100 $finish;
    end

    // Monitor PC + key registers + debug signals
    initial begin
        $monitor("T=%0t | PC=%h | x1=%d x2=%d x3=%d x4=%d x5=%h | alu_res=%d zero=%b branch=%b imm=%d",
                  $time,
                  uut.pc_out,
                  uut.rf_inst.regs[1],
                  uut.rf_inst.regs[2],
                  uut.rf_inst.regs[3],
                  uut.rf_inst.regs[4],
                  uut.rf_inst.regs[5],  // monitor x5 (link register)
                  alu_result,
                  alu_zero,
                  branch,
                  imm_out);
    end

endmodule