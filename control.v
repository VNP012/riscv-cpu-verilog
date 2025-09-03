//======================================================
// Main Control Unit (RV32I)
//======================================================
// Decodes opcode into high-level control signals.
// - Uses ALUOp for secondary decode in alu_control.
// - mem_to_reg: 1 -> write back from memory (loads)
// - alu_src   : 1 -> ALU B comes from immediate
// - branch    : 1 -> branch instruction (uses ALU for compare)
// - jump      : 1 -> JAL/JALR (write rd=PC+4; PC update via next-PC logic)
// - lui       : 1 -> write rd = imm (top-level will mux this later)
// - auipc     : 1 -> write rd = PC + imm (top-level will use PC as ALU srcA)
module control (
    input  wire [6:0] opcode,       // instr[6:0]
    output reg        reg_write,
    output reg        mem_read,
    output reg        mem_write,
    output reg        mem_to_reg,
    output reg        alu_src,
    output reg        branch,
    output reg        jump,
    output reg        lui,
    output reg        auipc,
    output reg [1:0]  alu_op        // 00: ADD, 01: BRANCH(SUB), 10: R/I decode
);

    always @* begin
        // Safe defaults
        reg_write = 0;
        mem_read  = 0;
        mem_write = 0;
        mem_to_reg= 0;
        alu_src   = 0;
        branch    = 0;
        jump      = 0;
        lui       = 0;
        auipc     = 0;
        alu_op    = 2'b00;

        case (opcode)
            7'b0110011: begin // R-type (ADD,SUB,AND,OR,XOR,SLL,SRL,SRA,SLT,SLTU)
                reg_write = 1;
                alu_src   = 0;
                alu_op    = 2'b10;
            end

            7'b0010011: begin // I-type ALU (ADDI, ANDI, ORI, XORI, SLLI, SRLI, SRAI, SLTI, SLTIU)
                reg_write = 1;
                alu_src   = 1;
                alu_op    = 2'b10;
            end

            7'b0000011: begin // LOAD (e.g., LW)
                reg_write = 1;
                mem_read  = 1;
                mem_to_reg= 1;
                alu_src   = 1;    // addr = rs1 + imm
                alu_op    = 2'b00; // ADD
            end

            7'b0100011: begin // STORE (e.g., SW)
                mem_write = 1;
                alu_src   = 1;    // addr = rs1 + imm
                alu_op    = 2'b00; // ADD
            end

            7'b1100011: begin // BRANCH (BEQ/BNE/BLT/...)
                branch    = 1;
                alu_src   = 0;
                alu_op    = 2'b01; // use SUB/compare in ALU
            end

            7'b1101111: begin // JAL
                reg_write = 1;    // rd = PC+4 (top will mux)
                jump      = 1;
                // alu_op don't care
            end

            7'b1100111: begin // JALR
                reg_write = 1;    // rd = PC+4
                jump      = 1;
                alu_src   = 1;    // target = rs1 + imm (handled in next PC logic)
                // alu_op don't care
            end

            7'b0110111: begin // LUI
                reg_write = 1;
                lui       = 1;    // rd = imm (top-level mux)
            end

            7'b0010111: begin // AUIPC
                reg_write = 1;
                auipc     = 1;    // rd = PC + imm (top uses PC as ALU srcA)
                alu_op    = 2'b00; // ADD
            end

            7'b1110011: begin // SYSTEM (e.g., ECALL) -> no writes in our simple core
                // all defaults
            end
        endcase
    end
endmodule