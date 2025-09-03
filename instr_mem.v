//======================================================
// Instruction Memory (Read-Only)
//======================================================

module instr_mem (
    input  wire [31:0] addr,       // PC address
    output wire [31:0] instr       // Instruction at addr
);

    // 256 x 32-bit memory (can hold 256 instructions)
    reg [31:0] mem [0:255];

    initial begin
        //==================================================
        // Test Program: JAL + JALR with clean return
        // x1 = 5
        // JAL to func: save PC+4 into x5 (link register)
        // func: x2 = x1 + 7
        // JALR back using x5
        // program halts with ECALL
        //==================================================

        mem[0] = 32'h00500093; // ADDI x1, x0, 5
        mem[1] = 32'h008002ef; // JAL x5, +8 (jump to PC=0x0C, x5=PC+4=0x08)
        mem[2] = 32'h00000073; // ECALL (halt after return)

        // function body @ PC=0x0C
        mem[3] = 32'h00708113; // ADDI x2, x1, 7  ; x2 = 12
        mem[4] = 32'h00028067; // JALR x0, 0(x5)  ; return to address in x5
    end

    // Word aligned access: addr[31:2]
    assign instr = mem[addr[9:2]];

endmodule