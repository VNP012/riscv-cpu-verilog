//======================================================
// Testbench for Immediate Generator
//======================================================

`timescale 1ns/1ps
module tb_imm_gen;

    reg  [31:0] instr;
    wire [31:0] imm_out;

    // Instantiate imm_gen
    imm_gen uut (
        .instr(instr),
        .imm_out(imm_out)
    );

    initial begin
        $dumpfile("tb_imm_gen.vcd");
        $dumpvars(0, tb_imm_gen);

        // I-type (ADDI x1, x0, 5) → imm = 5
        instr = 32'b000000000101_00000_000_00001_0010011;
        #10 $display("I-type ADDI imm = %d", imm_out);

        // S-type (SW x1, 8(x2)) → imm = 8
        instr = 32'b0000000_00001_00010_010_01000_0100011;
        #10 $display("S-type SW imm = %d", imm_out);

        // B-type (BEQ x1, x2, -4) → imm = -4
        instr = 32'b1111111_00010_00001_000_11100_1100011;
        #10 $display("B-type BEQ imm = %d", imm_out);

        // U-type (LUI x1, 0x12345) → imm = 0x12345000
        instr = 32'b00010010001101000101_00001_0110111;
        #10 $display("U-type LUI imm = %h", imm_out);

        // J-type (JAL x1, 16) → imm = 16
        instr = 32'b0000000000010_00000001_00001_1101111;
        #10 $display("J-type JAL imm = %d", imm_out);

        $finish;
    end

endmodule