`timescale 1ns / 1ps

module bootrom (
    input  wire         clk,
    input  wire         rst,

    input  wire         s_axilite_awvalid,
    output wire         s_axilite_awready,
    input  wire [15:0]  s_axilite_awaddr,
    input  wire [2:0]   s_axilite_awprot,

    input  wire         s_axilite_wvalid,
    output wire         s_axilite_wready,
    input  wire [31:0]  s_axilite_wdata,
    input  wire [3:0]   s_axilite_wstrb,

    output wire         s_axilite_bvalid,
    input  wire         s_axilite_bready,
    output wire [1:0]   s_axilite_bresp,

    input  wire         s_axilite_arvalid,
    output wire         s_axilite_arready,
    input  wire [15:0]  s_axilite_araddr,
    input  wire [2:0]   s_axilite_arprot,

    output wire         s_axilite_rvalid,
    input  wire         s_axilite_rready,
    output wire [31:0]  s_axilite_rdata,
    output wire [1:0]   s_axilite_rresp
);

    integer i;

    reg [31:0] ram_data [65536/4-1:0]; // 64KB

    initial begin
        ram_data[0] = 32'h0010029b; // addiw   t0,zero,1
        ram_data[1] = 32'h01f29293; // slli    t0,t0,  0x1f
        ram_data[2] = 32'h00028067; // jr      t0
    end

    // AXI lite read logic

    localparam [1:0]
        R_STATE_AXI_AR  = 2'd0,
        R_STATE_READ    = 2'd1,
        R_STATE_AXI_R   = 2'd2;

    reg [1:0] r_state, r_state_next;

    always @(posedge clk) begin
        if (rst)
            r_state <= R_STATE_AXI_AR;
        else
            r_state <= r_state_next;
    end

    always @* begin
        case (r_state)
            R_STATE_AXI_AR: r_state_next = s_axilite_arvalid ? R_STATE_READ : R_STATE_AXI_AR;
            R_STATE_READ:   r_state_next = R_STATE_AXI_R;
            R_STATE_AXI_R:  r_state_next = s_axilite_rready ? R_STATE_AXI_AR : R_STATE_AXI_R;
            default:        r_state_next = R_STATE_AXI_AR;
        endcase
    end

    reg [15:0] read_addr;

    always @(posedge clk)
        if (s_axilite_arvalid && s_axilite_arready)
            read_addr <= s_axilite_araddr;

    reg [31:0] read_data;

    always @(posedge clk) begin
        if (r_state == R_STATE_READ) begin
            read_data <= ram_data[read_addr[15:2]];
        end
    end

    assign s_axilite_arready    = r_state == R_STATE_AXI_AR;
    assign s_axilite_rvalid     = r_state == R_STATE_AXI_R;
    assign s_axilite_rdata      = read_data;
    assign s_axilite_rresp      = 2'b00;

    // AXI lite write logic

    localparam [1:0]
        W_STATE_AXI_AW  = 2'd0,
        W_STATE_AXI_W   = 2'd1,
        W_STATE_WRITE   = 2'd2,
        W_STATE_AXI_B   = 2'd3;

    reg [1:0] w_state, w_state_next;

    always @(posedge clk) begin
        if (rst)
            w_state <= W_STATE_AXI_AW;
        else
            w_state <= w_state_next;
    end

    always @* begin
        case (w_state)
            W_STATE_AXI_AW: w_state_next = s_axilite_awvalid ? W_STATE_AXI_W : W_STATE_AXI_AW;
            W_STATE_AXI_W:  w_state_next = s_axilite_wvalid ? W_STATE_WRITE : W_STATE_AXI_W;
            W_STATE_WRITE:  w_state_next = W_STATE_AXI_B;
            W_STATE_AXI_B:  w_state_next = s_axilite_bready ? W_STATE_AXI_AW : W_STATE_AXI_B;
            default:        w_state_next = W_STATE_AXI_AW;
        endcase
    end

    reg [15:0] write_addr;

    always @(posedge clk)
        if (s_axilite_awvalid && s_axilite_awready)
            write_addr <= s_axilite_awaddr;

    reg [31:0] write_data;
    reg [3:0] write_strb;

    always @(posedge clk) begin
        if (s_axilite_wvalid && s_axilite_wready) begin
            write_data <= s_axilite_wdata;
            write_strb <= s_axilite_wstrb;
        end
    end

    always @(posedge clk) begin
        if (w_state == W_STATE_WRITE)
            for (i=0; i<4; i=i+1)
                if (write_strb[i])
                    ram_data[write_addr[15:2]][i*8+:8] <= write_data[i*8+:8];
    end

    assign s_axilite_awready    = w_state == W_STATE_AXI_AW;
    assign s_axilite_wready     = w_state == W_STATE_AXI_W;
    assign s_axilite_bvalid     = w_state == W_STATE_AXI_B;
    assign s_axilite_bresp      = 2'b00;

endmodule
