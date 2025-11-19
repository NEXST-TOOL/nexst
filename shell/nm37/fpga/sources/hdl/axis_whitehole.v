`timescale 10 ns / 1 ns

module axis_whitehole #(
    parameter       DATA_WIDTH          = 32
)(
    input                       aclk,
    input                       aresetn,

    output                      m_axis_tvalid,
    input                       m_axis_tready,
    output [DATA_WIDTH-1:0]     m_axis_tdata,
    output [DATA_WIDTH/8-1:0]   m_axis_tkeep,
    output                      m_axis_tlast
);

    reg [7:0] cnt;

    always @(posedge aclk) begin
        if (!aresetn)
            cnt <= 0;
        else if (m_axis_tvalid && m_axis_tready)
            cnt <= cnt + 1;
    end

    genvar i;
    for (i=0; i<DATA_WIDTH/8; i=i+1) begin
        assign m_axis_tdata[i*8+:8] = cnt;
    end

    assign m_axis_tvalid = 1'b1;
    assign m_axis_tkeep = {DATA_WIDTH/8{1'b1}};
    assign m_axis_tlast = 1'b0;

endmodule
