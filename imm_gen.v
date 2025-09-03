//======================================================
// Immediate Generator (RISC-V)
//======================================================
// Supports: I-type, S-type, B-type, U-type, J-type
//======================================================

module imm_gen (
    input  wire [31:0] instr,     // full instruction
    output reg  [31:0] imm_out    // sign-extended immediate
);

    wire [6:0] opcode;
    assign opcode = instr[6:0];

    always @(*) begin
        case (opcode)
            // I-type (ADDI, LW, JALR, etc.)
            7'b0010011, // ADDI
            7'b0000011, // LW
            7'b1100111: // JALR
                imm_out = {{20{instr[31]}}, instr[31:20]};

            // S-type (SW)
            7'b0100011:
                imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};

            // B-type (BEQ, BNE, etc.)
            7'b1100011:
                imm_out = {{19{instr[31]}}, instr[31], instr[7],
                           instr[30:25], instr[11:8], 1'b0};

            // U-type (LUI, AUIPC)
            7'b0110111, // LUI
            7'b0010111: // AUIPC
                imm_out = {instr[31:12], 12'b0};

            // J-type (JAL)
            7'b1101111:
                imm_out = {{11{instr[31]}}, instr[31],
                           instr[19:12], instr[20],
                           instr[30:21], 1'b0};

            // Default (R-type, NOP, etc.)
            default:
                imm_out = 32'b0;
        endcase
    end

endmodule