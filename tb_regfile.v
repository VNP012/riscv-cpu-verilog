//======================================================
// Testbench for Register File
//======================================================

`timescale 1ns/1ps
module tb_regfile;

    reg clk;
    reg we;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] wd;
    wire [31:0] rd1, rd2;

    // Instantiate regfile
    regfile uut (
        .clk(clk),
        .we(we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_regfile.vcd");
        $dumpvars(0, tb_regfile);

        // Init
        clk = 0; we = 0; rs1 = 0; rs2 = 0; rd = 0; wd = 0;

        // Write 10 into x1
        #10 we = 1; rd = 5'd1; wd = 32'd10;
        #10 we = 0;

        // Write 20 into x2
        #10 we = 1; rd = 5'd2; wd = 32'd20;
        #10 we = 0;

        // Read from x1 and x2
        #10 rs1 = 5'd1; rs2 = 5'd2;

        // Try to write to x0 (should stay 0)
        #10 we = 1; rd = 5'd0; wd = 32'd99;
        #10 we = 0;

        // Read x0
        #10 rs1 = 5'd0; rs2 = 5'd0;

        #20 $finish;
    end

    // Monitor
    initial begin
        $monitor("T=%0t | rs1=%d rd1=%d | rs2=%d rd2=%d", 
                  $time, rs1, rd1, rs2, rd2);
    end

endmodule