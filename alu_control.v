//======================================================
// ALU Control (RV32I)
//======================================================
module alu_control (
    input  wire [1:0] alu_op,
    input  wire [2:0] funct3,    // instr[14:12]
    input  wire       funct7b5,  // instr[30]
    output reg  [3:0] alu_sel
);

    // ALU operation encodings
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_AND  = 4'b0010;
    localparam ALU_OR   = 4'b0011;
    localparam ALU_XOR  = 4'b0100;
    localparam ALU_SLT  = 4'b0101;
    localparam ALU_SLTU = 4'b0110;
    localparam ALU_SLL  = 4'b0111;
    localparam ALU_SRL  = 4'b1000;
    localparam ALU_SRA  = 4'b1001;

    always @* begin
        case (alu_op)
            2'b00: alu_sel = ALU_ADD; // loads/stores/AUIPC
            2'b01: alu_sel = ALU_SUB; // branches
            2'b10: begin
                case (funct3)
                    3'b000: alu_sel = (funct7b5 ? ALU_SUB : ALU_ADD);
                    3'b111: alu_sel = ALU_AND;
                    3'b110: alu_sel = ALU_OR;
                    3'b100: alu_sel = ALU_XOR;
                    3'b010: alu_sel = ALU_SLT;
                    3'b011: alu_sel = ALU_SLTU;
                    3'b001: alu_sel = ALU_SLL;
                    3'b101: alu_sel = (funct7b5 ? ALU_SRA : ALU_SRL);
                    default: alu_sel = ALU_ADD;
                endcase
            end
            default: alu_sel = ALU_ADD;
        endcase
    end
endmodule