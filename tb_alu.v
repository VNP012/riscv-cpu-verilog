//======================================================
// Testbench for ALU
//======================================================

`timescale 1ns/1ps
module tb_alu;

    reg  [31:0] a, b;
    reg  [3:0]  alu_sel;
    wire [31:0] result;
    wire        zero;

    // Instantiate ALU
    alu uut (
        .a(a),
        .b(b),
        .alu_sel(alu_sel),
        .result(result),
        .zero(zero)
    );

    initial begin
        $dumpfile("tb_alu.vcd");
        $dumpvars(0, tb_alu);

        // Test ADD
        a = 10; b = 20; alu_sel = 4'b0000; #10;
        $display("ADD: %d + %d = %d", a, b, result);

        // Test SUB
        a = 20; b = 10; alu_sel = 4'b0001; #10;
        $display("SUB: %d - %d = %d", a, b, result);

        // Test AND
        a = 32'hF0F0; b = 32'h0FF0; alu_sel = 4'b0010; #10;
        $display("AND: %h & %h = %h", a, b, result);

        // Test OR
        alu_sel = 4'b0011; #10;
        $display("OR : %h | %h = %h", a, b, result);

        // Test XOR
        alu_sel = 4'b0100; #10;
        $display("XOR: %h ^ %h = %h", a, b, result);

        // Test SLT (signed compare)
        a = -5; b = 3; alu_sel = 4'b0101; #10;
        $display("SLT: %d < %d ? %d", a, b, result);

        // Test SLTU (unsigned compare)
        a = -5; b = 3; alu_sel = 4'b0110; #10;
        $display("SLTU: %u < %u ? %d", a, b, result);

        // Test SLL
        a = 32'h1; b = 32'd4; alu_sel = 4'b0111; #10;
        $display("SLL: %h << %d = %h", a, b, result);

        // Test SRL
        a = 32'hF0; b = 32'd4; alu_sel = 4'b1000; #10;
        $display("SRL: %h >> %d = %h", a, b, result);

        // Test SRA
        a = -32'd16; b = 32'd2; alu_sel = 4'b1001; #10;
        $display("SRA: %d >>> %d = %d", a, b, result);

        // Test Zero flag
        a = 5; b = 5; alu_sel = 4'b0001; #10;
        $display("Zero flag test: %d - %d = %d | zero=%b", a, b, result, zero);

        $finish;
    end

endmodule