//======================================================
// Top-Level CPU (Single-Cycle RV32I Core)
//======================================================

module cpu_top (
    input  wire clk,
    input  wire reset,

    // Debug outputs for testbench visibility
    output wire [31:0] alu_result,
    output wire        alu_zero,
    output wire        branch,
    output wire [31:0] imm_out
);

    // --- PC & Instruction Memory ---
    wire [31:0] pc_out, next_pc, instr;

    pc pc_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc_out(pc_out)
    );

    instr_mem imem_inst (
        .addr(pc_out),
        .instr(instr)
    );

    // --- Decode Fields ---
    wire [6:0] opcode  = instr[6:0];
    wire [4:0] rd      = instr[11:7];
    wire [2:0] funct3  = instr[14:12];
    wire [4:0] rs1     = instr[19:15];
    wire [4:0] rs2     = instr[24:20];
    wire [6:0] funct7  = instr[31:25];

    // --- Control Signals ---
    wire reg_write, mem_read, mem_write, mem_to_reg;
    wire alu_src, jump, lui, auipc;
    wire [1:0] alu_op;

    control control_inst (
        .opcode(opcode),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .branch(branch),   // exposed
        .jump(jump),
        .lui(lui),
        .auipc(auipc),
        .alu_op(alu_op)
    );

    // --- Immediate Generator ---
    imm_gen imm_inst (
        .instr(instr),
        .imm_out(imm_out)  // exposed
    );

    // --- Register File ---
    wire [31:0] rd1, rd2;
    wire [31:0] write_data;

    regfile rf_inst (
        .clk(clk),
        .we(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(write_data),
        .rd1(rd1),
        .rd2(rd2)
    );

    // --- ALU Control ---
    wire [3:0] alu_sel;
    alu_control alu_ctrl_inst (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7b5(funct7[5]),
        .alu_sel(alu_sel)
    );

    // --- ALU ---
    wire [31:0] alu_b = (alu_src) ? imm_out : rd2;

    alu alu_inst (
        .a(rd1),
        .b(alu_b),
        .alu_sel(alu_sel),
        .result(alu_result), // exposed
        .zero(alu_zero)      // exposed
    );

    // --- Data Memory ---
    wire [31:0] data_read;

    data_mem dmem_inst (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(alu_result),
        .write_data(rd2),
        .read_data(data_read)
    );

    // --- Write-back Selection ---
    assign write_data =
        (lui)   ? imm_out :
        (auipc) ? (pc_out + imm_out) :
        (jump)  ? (pc_out + 4) :             // FIX: JAL/JALR write PC+4 into rd
        (mem_to_reg ? data_read : alu_result);

    // --- Next PC Logic with Branch/Jump ---
    wire take_branch   = branch & alu_zero;
    wire [31:0] pc_plus_4 = pc_out + 4;
    wire [31:0] pc_branch = pc_out + imm_out;
    wire [31:0] pc_jalr   = (rd1 + imm_out) & ~32'b1; // JALR target, LSB forced 0

    assign next_pc = jump ? (opcode == 7'b1101111 ? pc_out + imm_out : pc_jalr) :
                      take_branch ? pc_branch :
                      pc_plus_4;

endmodule