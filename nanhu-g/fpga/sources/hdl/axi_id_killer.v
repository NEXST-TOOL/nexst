`timescale 1ns / 1ps

module axi_id_killer #(
    parameter   ADDR_WIDTH      = 32,
    parameter   DATA_WIDTH      = 64,
    parameter   ID_WIDTH        = 4,
    parameter   MAX_R_INFLIGHT  = 8,
    parameter   MAX_W_INFLIGHT  = 8
)(
    input                       aclk,
    input                       aresetn,

    input                       s_axi_awvalid,
    output                      s_axi_awready,
    input  [ADDR_WIDTH-1:0]     s_axi_awaddr,
    input  [ID_WIDTH-1:0]       s_axi_awid,
    input  [7:0]                s_axi_awlen,
    input  [2:0]                s_axi_awsize,
    input  [1:0]                s_axi_awburst,
    input  [0:0]                s_axi_awlock,
    input  [3:0]                s_axi_awcache,
    input  [2:0]                s_axi_awprot,
    input  [3:0]                s_axi_awqos,
    input  [3:0]                s_axi_awregion,
    input                       s_axi_arvalid,
    output                      s_axi_arready,
    input  [ADDR_WIDTH-1:0]     s_axi_araddr,
    input  [ID_WIDTH-1:0]       s_axi_arid,
    input  [7:0]                s_axi_arlen,
    input  [2:0]                s_axi_arsize,
    input  [1:0]                s_axi_arburst,
    input  [0:0]                s_axi_arlock,
    input  [3:0]                s_axi_arcache,
    input  [2:0]                s_axi_arprot,
    input  [3:0]                s_axi_arqos,
    input  [3:0]                s_axi_arregion,
    input                       s_axi_wvalid,
    output                      s_axi_wready,
    input  [DATA_WIDTH-1:0]     s_axi_wdata,
    input  [DATA_WIDTH/8-1:0]   s_axi_wstrb,
    input                       s_axi_wlast,
    output                      s_axi_bvalid,
    input                       s_axi_bready,
    output [1:0]                s_axi_bresp,
    output [ID_WIDTH-1:0]       s_axi_bid,
    output                      s_axi_rvalid,
    input                       s_axi_rready,
    output [DATA_WIDTH-1:0]     s_axi_rdata,
    output [1:0]                s_axi_rresp,
    output [ID_WIDTH-1:0]       s_axi_rid,
    output                      s_axi_rlast,

    output                      m_axi_awvalid,
    input                       m_axi_awready,
    output [ADDR_WIDTH-1:0]     m_axi_awaddr,
    output [7:0]                m_axi_awlen,
    output [2:0]                m_axi_awsize,
    output [1:0]                m_axi_awburst,
    output [0:0]                m_axi_awlock,
    output [3:0]                m_axi_awcache,
    output [2:0]                m_axi_awprot,
    output [3:0]                m_axi_awqos,
    output [3:0]                m_axi_awregion,
    output                      m_axi_arvalid,
    input                       m_axi_arready,
    output [ADDR_WIDTH-1:0]     m_axi_araddr,
    output [7:0]                m_axi_arlen,
    output [2:0]                m_axi_arsize,
    output [1:0]                m_axi_arburst,
    output [0:0]                m_axi_arlock,
    output [3:0]                m_axi_arcache,
    output [2:0]                m_axi_arprot,
    output [3:0]                m_axi_arqos,
    output [3:0]                m_axi_arregion,
    output                      m_axi_wvalid,
    input                       m_axi_wready,
    output [DATA_WIDTH-1:0]     m_axi_wdata,
    output [DATA_WIDTH/8-1:0]   m_axi_wstrb,
    output                      m_axi_wlast,
    input                       m_axi_bvalid,
    output                      m_axi_bready,
    input  [1:0]                m_axi_bresp,
    input                       m_axi_rvalid,
    output                      m_axi_rready,
    input  [DATA_WIDTH-1:0]     m_axi_rdata,
    input  [1:0]                m_axi_rresp,
    input                       m_axi_rlast
);

    wire rid_q_write;
    wire rid_q_full;
    wire rid_q_read;

    axi_id_killer_fifo #(
        .WIDTH  (ID_WIDTH),
        .DEPTH  (MAX_R_INFLIGHT)
    ) rid_q (
        .clk    (aclk),
        .rst    (!aresetn),
        .winc   (rid_q_write),
        .wfull  (rid_q_full),
        .wdata  (s_axi_arid),
        .rinc   (rid_q_read),
        .rempty (),
        .rdata  (s_axi_rid)
    );

    assign m_axi_arvalid    = s_axi_arvalid && !rid_q_full;
    assign s_axi_arready    = m_axi_arready && !rid_q_full;
    assign m_axi_araddr     = s_axi_araddr;
    assign m_axi_arlen      = s_axi_arlen;
    assign m_axi_arsize     = s_axi_arsize;
    assign m_axi_arburst    = s_axi_arburst;
    assign m_axi_arlock     = s_axi_arlock;
    assign m_axi_arcache    = s_axi_arcache;
    assign m_axi_arprot     = s_axi_arprot;
    assign m_axi_arqos      = s_axi_arqos;
    assign m_axi_arregion   = s_axi_arregion;

    assign s_axi_rvalid = m_axi_rvalid;
    assign m_axi_rready = s_axi_rready;
    assign s_axi_rdata  = m_axi_rdata;
    assign s_axi_rresp  = m_axi_rresp;
    assign s_axi_rlast  = m_axi_rlast;

    assign rid_q_write = s_axi_arvalid && s_axi_arready;
    assign rid_q_read = s_axi_rvalid && s_axi_rready && s_axi_rlast;

    wire wid_q_write;
    wire wid_q_full;
    wire wid_q_read;

    axi_id_killer_fifo #(
        .WIDTH  (ID_WIDTH),
        .DEPTH  (MAX_W_INFLIGHT)
    ) wid_q (
        .clk    (aclk),
        .rst    (!aresetn),
        .winc   (wid_q_write),
        .wfull  (wid_q_full),
        .wdata  (s_axi_awid),
        .rinc   (wid_q_read),
        .rempty (),
        .rdata  (s_axi_bid)
    );

    assign m_axi_awvalid    = s_axi_awvalid && !wid_q_full;
    assign s_axi_awready    = m_axi_awready && !wid_q_full;
    assign m_axi_awaddr     = s_axi_awaddr;
    assign m_axi_awlen      = s_axi_awlen;
    assign m_axi_awsize     = s_axi_awsize;
    assign m_axi_awburst    = s_axi_awburst;
    assign m_axi_awlock     = s_axi_awlock;
    assign m_axi_awcache    = s_axi_awcache;
    assign m_axi_awprot     = s_axi_awprot;
    assign m_axi_awqos      = s_axi_awqos;
    assign m_axi_awregion   = s_axi_awregion;

    assign m_axi_wvalid     = s_axi_wvalid;
    assign s_axi_wready     = m_axi_wready;
    assign m_axi_wdata      = s_axi_wdata;
    assign m_axi_wstrb      = s_axi_wstrb;
    assign m_axi_wlast      = s_axi_wlast;

    assign s_axi_bvalid     = m_axi_bvalid;
    assign m_axi_bready     = s_axi_bready;
    assign s_axi_bresp      = m_axi_bresp;

    assign wid_q_write = s_axi_awvalid && s_axi_awready;
    assign wid_q_read = s_axi_bvalid && s_axi_bready;

endmodule