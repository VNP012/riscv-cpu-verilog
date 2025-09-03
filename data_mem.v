//======================================================
// Data Memory (for LW/SW)
//======================================================

module data_mem (
    input  wire        clk,
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    output reg  [31:0] read_data
);

    // 256 x 32-bit memory
    reg [31:0] mem [0:255];

    // Write on rising edge
    always @(posedge clk) begin
        if (mem_write)
            mem[addr[9:2]] <= write_data;
    end

    // Read (combinational)
    always @(*) begin
        if (mem_read)
            read_data = mem[addr[9:2]];
        else
            read_data = 32'b0;
    end

endmodule