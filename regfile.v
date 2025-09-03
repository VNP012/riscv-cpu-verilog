//======================================================
// Register File (32 x 32-bit)
//======================================================

module regfile (
    input  wire        clk,
    input  wire        we,           // write enable
    input  wire [4:0]  rs1,          // source register 1
    input  wire [4:0]  rs2,          // source register 2
    input  wire [4:0]  rd,           // destination register
    input  wire [31:0] wd,           // write data
    output wire [31:0] rd1,          // read data 1
    output wire [31:0] rd2           // read data 2
);

    reg [31:0] regs [0:31];

    // Read is asynchronous
    assign rd1 = (rs1 != 0) ? regs[rs1] : 0;  // x0 always 0
    assign rd2 = (rs2 != 0) ? regs[rs2] : 0;

    // Write is synchronous
    always @(posedge clk) begin
        if (we && (rd != 0))  // cannot write to x0
            regs[rd] <= wd;
    end

endmodule