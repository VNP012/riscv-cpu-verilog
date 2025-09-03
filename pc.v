//======================================================
// Program Counter (PC)
//======================================================

module pc (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] next_pc,   // next PC value (from PC logic)
    output reg  [31:0] pc_out     // current PC value
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_out <= 32'h00000000;   // start at address 0
        else
            pc_out <= next_pc;        // update with next PC
    end

endmodule