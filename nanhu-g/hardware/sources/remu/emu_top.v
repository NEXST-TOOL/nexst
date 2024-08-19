`timescale 1 ns / 1 ps

module emu_top(
    (* remu_clock *)
    input   clk,
    (* remu_signal *)
    input   rst
);

    wire          io_mem_awready;
    wire          io_mem_awvalid;
    wire   [35:0] io_mem_awaddr;
    wire   [2:0]  io_mem_awprot;
    wire   [13:0] io_mem_awid;
    wire          io_mem_awuser;
    wire   [7:0]  io_mem_awlen;
    wire   [2:0]  io_mem_awsize;
    wire   [1:0]  io_mem_awburst;
    wire          io_mem_awlock;
    wire   [3:0]  io_mem_awcache;
    wire   [3:0]  io_mem_awqos;
    wire          io_mem_wready;
    wire          io_mem_wvalid;
    wire   [255:0]io_mem_wdata;
    wire   [31:0] io_mem_wstrb;
    wire          io_mem_wlast;
    wire          io_mem_bready;
    wire          io_mem_bvalid;
    wire   [1:0]  io_mem_bresp;
    wire   [13:0] io_mem_bid;
    wire          io_mem_buser;
    wire          io_mem_arready;
    wire          io_mem_arvalid;
    wire   [35:0] io_mem_araddr;
    wire   [2:0]  io_mem_arprot;
    wire   [13:0] io_mem_arid;
    wire          io_mem_aruser;
    wire   [7:0]  io_mem_arlen;
    wire   [2:0]  io_mem_arsize;
    wire   [1:0]  io_mem_arburst;
    wire          io_mem_arlock;
    wire   [3:0]  io_mem_arcache;
    wire   [3:0]  io_mem_arqos;
    wire          io_mem_rready;
    wire          io_mem_rvalid;
    wire   [1:0]  io_mem_rresp;
    wire   [255:0]io_mem_rdata;
    wire          io_mem_rlast;
    wire   [13:0] io_mem_rid;
    wire          io_mem_ruser;

    wire          io_mmio_awready;
    wire          io_mmio_awvalid;
    wire   [31:0] io_mmio_awaddr;
    wire   [2:0]  io_mmio_awprot;
    wire   [1:0]  io_mmio_awid;
    wire          io_mmio_awuser;
    wire   [7:0]  io_mmio_awlen;
    wire   [2:0]  io_mmio_awsize;
    wire   [1:0]  io_mmio_awburst;
    wire          io_mmio_awlock;
    wire   [3:0]  io_mmio_awcache;
    wire   [3:0]  io_mmio_awqos;
    wire          io_mmio_wready;
    wire          io_mmio_wvalid;
    wire   [63:0] io_mmio_wdata;
    wire   [7:0]  io_mmio_wstrb;
    wire          io_mmio_wlast;
    wire          io_mmio_bready;
    wire          io_mmio_bvalid;
    wire   [1:0]  io_mmio_bresp;
    wire   [1:0]  io_mmio_bid;
    wire          io_mmio_buser;
    wire          io_mmio_arready;
    wire          io_mmio_arvalid;
    wire   [31:0] io_mmio_araddr;
    wire   [2:0]  io_mmio_arprot;
    wire   [1:0]  io_mmio_arid;
    wire          io_mmio_aruser;
    wire   [7:0]  io_mmio_arlen;
    wire   [2:0]  io_mmio_arsize;
    wire   [1:0]  io_mmio_arburst;
    wire          io_mmio_arlock;
    wire   [3:0]  io_mmio_arcache;
    wire   [3:0]  io_mmio_arqos;
    wire          io_mmio_rready;
    wire          io_mmio_rvalid;
    wire   [1:0]  io_mmio_rresp;
    wire   [63:0] io_mmio_rdata;
    wire          io_mmio_rlast;
    wire   [1:0]  io_mmio_rid;
    wire          io_mmio_ruser;

    wire uart_intr;

    XSTop xs(
        .dma_0_awready  (),
        .dma_0_awvalid  (),
        .dma_0_awid     (),
        .dma_0_awaddr   (),
        .dma_0_awlen    (),
        .dma_0_awsize   (),
        .dma_0_awburst  (),
        .dma_0_awlock   (),
        .dma_0_awcache  (),
        .dma_0_awprot   (),
        .dma_0_awqos    (),
        .dma_0_wready   (),
        .dma_0_wvalid   (),
        .dma_0_wdata    (),
        .dma_0_wstrb    (),
        .dma_0_wlast    (),
        .dma_0_bready   (),
        .dma_0_bvalid   (),
        .dma_0_bid      (),
        .dma_0_bresp    (),
        .dma_0_arready  (),
        .dma_0_arvalid  (),
        .dma_0_arid     (),
        .dma_0_araddr   (),
        .dma_0_arlen    (),
        .dma_0_arsize   (),
        .dma_0_arburst  (),
        .dma_0_arlock   (),
        .dma_0_arcache  (),
        .dma_0_arprot   (),
        .dma_0_arqos    (),
        .dma_0_rready   (),
        .dma_0_rvalid   (),
        .dma_0_rid      (),
        .dma_0_rdata    (),
        .dma_0_rresp    (),
        .dma_0_rlast    (),
        .peripheral_0_awready   (io_mmio_awready),
        .peripheral_0_awvalid   (io_mmio_awvalid),
        .peripheral_0_awid      (io_mmio_awid),
        .peripheral_0_awaddr    (io_mmio_awaddr),
        .peripheral_0_awlen     (io_mmio_awlen),
        .peripheral_0_awsize    (io_mmio_awsize),
        .peripheral_0_awburst   (io_mmio_awburst),
        .peripheral_0_awlock    (io_mmio_awlock),
        .peripheral_0_awcache   (io_mmio_awcache),
        .peripheral_0_awprot    (io_mmio_awprot),
        .peripheral_0_awqos     (io_mmio_awqos),
        .peripheral_0_wready    (io_mmio_wready),
        .peripheral_0_wvalid    (io_mmio_wvalid),
        .peripheral_0_wdata     (io_mmio_wdata),
        .peripheral_0_wstrb     (io_mmio_wstrb),
        .peripheral_0_wlast     (io_mmio_wlast),
        .peripheral_0_bready    (io_mmio_bready),
        .peripheral_0_bvalid    (io_mmio_bvalid),
        .peripheral_0_bid       (io_mmio_bid),
        .peripheral_0_bresp     (io_mmio_bresp),
        .peripheral_0_arready   (io_mmio_arready),
        .peripheral_0_arvalid   (io_mmio_arvalid),
        .peripheral_0_arid      (io_mmio_arid),
        .peripheral_0_araddr    (io_mmio_araddr),
        .peripheral_0_arlen     (io_mmio_arlen),
        .peripheral_0_arsize    (io_mmio_arsize),
        .peripheral_0_arburst   (io_mmio_arburst),
        .peripheral_0_arlock    (io_mmio_arlock),
        .peripheral_0_arcache   (io_mmio_arcache),
        .peripheral_0_arprot    (io_mmio_arprot),
        .peripheral_0_arqos     (io_mmio_arqos),
        .peripheral_0_rready    (io_mmio_rready),
        .peripheral_0_rvalid    (io_mmio_rvalid),
        .peripheral_0_rid       (io_mmio_rid),
        .peripheral_0_rdata     (io_mmio_rdata),
        .peripheral_0_rresp     (io_mmio_rresp),
        .peripheral_0_rlast     (io_mmio_rlast),
        .memory_0_awready       (io_mem_awready),
        .memory_0_awvalid       (io_mem_awvalid),
        .memory_0_awid          (io_mem_awid),
        .memory_0_awaddr        (io_mem_awaddr),
        .memory_0_awlen         (io_mem_awlen),
        .memory_0_awsize        (io_mem_awsize),
        .memory_0_awburst       (io_mem_awburst),
        .memory_0_awlock        (io_mem_awlock),
        .memory_0_awcache       (io_mem_awcache),
        .memory_0_awprot        (io_mem_awprot),
        .memory_0_awqos         (io_mem_awqos),
        .memory_0_wready        (io_mem_wready),
        .memory_0_wvalid        (io_mem_wvalid),
        .memory_0_wdata         (io_mem_wdata),
        .memory_0_wstrb         (io_mem_wstrb),
        .memory_0_wlast         (io_mem_wlast),
        .memory_0_bready        (io_mem_bready),
        .memory_0_bvalid        (io_mem_bvalid),
        .memory_0_bid           (io_mem_bid),
        .memory_0_bresp         (io_mem_bresp),
        .memory_0_arready       (io_mem_arready),
        .memory_0_arvalid       (io_mem_arvalid),
        .memory_0_arid          (io_mem_arid),
        .memory_0_araddr        (io_mem_araddr),
        .memory_0_arlen         (io_mem_arlen),
        .memory_0_arsize        (io_mem_arsize),
        .memory_0_arburst       (io_mem_arburst),
        .memory_0_arlock        (io_mem_arlock),
        .memory_0_arcache       (io_mem_arcache),
        .memory_0_arprot        (io_mem_arprot),
        .memory_0_arqos         (io_mem_arqos),
        .memory_0_rready        (io_mem_rready),
        .memory_0_rvalid        (io_mem_rvalid),
        .memory_0_rid           (io_mem_rid),
        .memory_0_rdata         (io_mem_rdata),
        .memory_0_rresp         (io_mem_rresp),
        .memory_0_rlast         (io_mem_rlast),
        .io_clock           (clk),
        .io_reset           (rst),
        .io_sram_config     (),
        .io_extIntrs        (uart_intr),
        .io_pll0_lock       (),
        .io_pll0_ctrl_0     (),
        .io_pll0_ctrl_1     (),
        .io_pll0_ctrl_2     (),
        .io_pll0_ctrl_3     (),
        .io_pll0_ctrl_4     (),
        .io_pll0_ctrl_5     (),
        .io_systemjtag_jtag_TCK             (clk),
        .io_systemjtag_jtag_TMS             (),
        .io_systemjtag_jtag_TDI             (),
        .io_systemjtag_jtag_TDO_data        (),
        .io_systemjtag_jtag_TDO_driven      (),
        .io_systemjtag_reset                (1'b1),
        .io_systemjtag_mfr_id               (),
        .io_systemjtag_part_number          (),
        .io_systemjtag_version              (),
        .io_debug_reset                     (),
        .io_cacheable_check_req_0_valid     (),
        .io_cacheable_check_req_0_bits_addr (),
        .io_cacheable_check_req_0_bits_size (),
        .io_cacheable_check_req_0_bits_cmd  (),
        .io_cacheable_check_req_1_valid     (),
        .io_cacheable_check_req_1_bits_addr (),
        .io_cacheable_check_req_1_bits_size (),
        .io_cacheable_check_req_1_bits_cmd  (),
        .io_cacheable_check_resp_0_ld       (),
        .io_cacheable_check_resp_0_st       (),
        .io_cacheable_check_resp_0_instr    (),
        .io_cacheable_check_resp_0_mmio     (),
        .io_cacheable_check_resp_1_ld       (),
        .io_cacheable_check_resp_1_st       (),
        .io_cacheable_check_resp_1_instr    (),
        .io_cacheable_check_resp_1_mmio     (),
        .io_riscv_halt_0                    ()
    );

    wire          mem_noid_awready;
    wire          mem_noid_awvalid;
    wire   [35:0] mem_noid_awaddr;
    wire   [2:0]  mem_noid_awprot;
    wire          mem_noid_awuser;
    wire   [7:0]  mem_noid_awlen;
    wire   [2:0]  mem_noid_awsize;
    wire   [1:0]  mem_noid_awburst;
    wire          mem_noid_awlock;
    wire   [3:0]  mem_noid_awcache;
    wire   [3:0]  mem_noid_awqos;
    wire          mem_noid_wready;
    wire          mem_noid_wvalid;
    wire   [255:0]mem_noid_wdata;
    wire   [31:0] mem_noid_wstrb;
    wire          mem_noid_wlast;
    wire          mem_noid_bready;
    wire          mem_noid_bvalid;
    wire   [1:0]  mem_noid_bresp;
    wire          mem_noid_buser;
    wire          mem_noid_arready;
    wire          mem_noid_arvalid;
    wire   [35:0] mem_noid_araddr;
    wire   [2:0]  mem_noid_arprot;
    wire          mem_noid_aruser;
    wire   [7:0]  mem_noid_arlen;
    wire   [2:0]  mem_noid_arsize;
    wire   [1:0]  mem_noid_arburst;
    wire          mem_noid_arlock;
    wire   [3:0]  mem_noid_arcache;
    wire   [3:0]  mem_noid_arqos;
    wire          mem_noid_rready;
    wire          mem_noid_rvalid;
    wire   [1:0]  mem_noid_rresp;
    wire   [255:0]mem_noid_rdata;
    wire          mem_noid_rlast;
    wire          mem_noid_ruser;

    axi_id_killer #(
        .ADDR_WIDTH     (36),
        .DATA_WIDTH     (256),
        .ID_WIDTH       (14),
        .MAX_R_INFLIGHT (8),
        .MAX_W_INFLIGHT (8)
    ) id_killer (
        .aclk       (clk),
        .aresetn    (!rst),
        .s_axi_awvalid  (io_mem_awvalid),
        .s_axi_awready  (io_mem_awready),
        .s_axi_awaddr   (io_mem_awaddr),
        .s_axi_awid     (io_mem_awid),
        .s_axi_awlen    (io_mem_awlen),
        .s_axi_awsize   (io_mem_awsize),
        .s_axi_awburst  (io_mem_awburst),
        .s_axi_awlock   (io_mem_awlock),
        .s_axi_awcache  (io_mem_awcache),
        .s_axi_awprot   (io_mem_awprot),
        .s_axi_awqos    (io_mem_awqos),
        .s_axi_awregion (4'd0),
        .s_axi_arvalid  (io_mem_arvalid),
        .s_axi_arready  (io_mem_arready),
        .s_axi_araddr   (io_mem_araddr),
        .s_axi_arid     (io_mem_arid),
        .s_axi_arlen    (io_mem_arlen),
        .s_axi_arsize   (io_mem_arsize),
        .s_axi_arburst  (io_mem_arburst),
        .s_axi_arlock   (io_mem_arlock),
        .s_axi_arcache  (io_mem_arcache),
        .s_axi_arprot   (io_mem_arprot),
        .s_axi_arqos    (io_mem_arqos),
        .s_axi_arregion (4'd0),
        .s_axi_wvalid   (io_mem_wvalid),
        .s_axi_wready   (io_mem_wready),
        .s_axi_wdata    (io_mem_wdata),
        .s_axi_wstrb    (io_mem_wstrb),
        .s_axi_wlast    (io_mem_wlast),
        .s_axi_bvalid   (io_mem_bvalid),
        .s_axi_bready   (io_mem_bready),
        .s_axi_bresp    (io_mem_bresp),
        .s_axi_bid      (io_mem_bid),
        .s_axi_rvalid   (io_mem_rvalid),
        .s_axi_rready   (io_mem_rready),
        .s_axi_rdata    (io_mem_rdata),
        .s_axi_rresp    (io_mem_rresp),
        .s_axi_rid      (io_mem_rid),
        .s_axi_rlast    (io_mem_rlast),
        .m_axi_awvalid  (mem_noid_awvalid),
        .m_axi_awready  (mem_noid_awready),
        .m_axi_awaddr   (mem_noid_awaddr),
        .m_axi_awlen    (mem_noid_awlen),
        .m_axi_awsize   (mem_noid_awsize),
        .m_axi_awburst  (mem_noid_awburst),
        .m_axi_awlock   (mem_noid_awlock),
        .m_axi_awcache  (mem_noid_awcache),
        .m_axi_awprot   (mem_noid_awprot),
        .m_axi_awqos    (mem_noid_awqos),
        .m_axi_awregion (),
        .m_axi_arvalid  (mem_noid_arvalid),
        .m_axi_arready  (mem_noid_arready),
        .m_axi_araddr   (mem_noid_araddr),
        .m_axi_arlen    (mem_noid_arlen),
        .m_axi_arsize   (mem_noid_arsize),
        .m_axi_arburst  (mem_noid_arburst),
        .m_axi_arlock   (mem_noid_arlock),
        .m_axi_arcache  (mem_noid_arcache),
        .m_axi_arprot   (mem_noid_arprot),
        .m_axi_arqos    (mem_noid_arqos),
        .m_axi_arregion (),
        .m_axi_wvalid   (mem_noid_wvalid),
        .m_axi_wready   (mem_noid_wready),
        .m_axi_wdata    (mem_noid_wdata),
        .m_axi_wstrb    (mem_noid_wstrb),
        .m_axi_wlast    (mem_noid_wlast),
        .m_axi_bvalid   (mem_noid_bvalid),
        .m_axi_bready   (mem_noid_bready),
        .m_axi_bresp    (mem_noid_bresp),
        .m_axi_rvalid   (mem_noid_rvalid),
        .m_axi_rready   (mem_noid_rready),
        .m_axi_rdata    (mem_noid_rdata),
        .m_axi_rresp    (mem_noid_rresp),
        .m_axi_rlast    (mem_noid_rlast)
    );

    wire [31:0] mmio_axil_awaddr;
    wire [2:0]  mmio_axil_awprot;
    wire        mmio_axil_awvalid;
    wire        mmio_axil_awready;
    wire [31:0] mmio_axil_wdata;
    wire [3:0]  mmio_axil_wstrb;
    wire        mmio_axil_wvalid;
    wire        mmio_axil_wready;
    wire [1:0]  mmio_axil_bresp;
    wire        mmio_axil_bvalid;
    wire        mmio_axil_bready;
    wire [31:0] mmio_axil_araddr;
    wire [2:0]  mmio_axil_arprot;
    wire        mmio_axil_arvalid;
    wire        mmio_axil_arready;
    wire [31:0] mmio_axil_rdata;
    wire [1:0]  mmio_axil_rresp;
    wire        mmio_axil_rvalid;
    wire        mmio_axil_rready;

    axi_axil_adapter #(
        .ADDR_WIDTH         (32),
        .AXI_DATA_WIDTH     (64),
        .AXI_ID_WIDTH       (2),
        .AXIL_DATA_WIDTH    (32)
    ) mmio_axi_to_axil (
        .clk                (clk),
        .rst                (rst),
        .s_axi_awid         (io_mmio_awid),
        .s_axi_awaddr       (io_mmio_awaddr),
        .s_axi_awlen        (io_mmio_awlen),
        .s_axi_awsize       (io_mmio_awsize),
        .s_axi_awburst      (io_mmio_awburst),
        .s_axi_awlock       (io_mmio_awlock),
        .s_axi_awcache      (io_mmio_awcache),
        .s_axi_awregion     (4'd0),
        .s_axi_awqos        (io_mmio_awqos),
        .s_axi_awprot       (io_mmio_awprot),
        .s_axi_awvalid      (io_mmio_awvalid),
        .s_axi_awready      (io_mmio_awready),
        .s_axi_wdata        (io_mmio_wdata),
        .s_axi_wstrb        (io_mmio_wstrb),
        .s_axi_wlast        (io_mmio_wlast),
        .s_axi_wvalid       (io_mmio_wvalid),
        .s_axi_wready       (io_mmio_wready),
        .s_axi_bid          (io_mmio_bid),
        .s_axi_bresp        (io_mmio_bresp),
        .s_axi_bvalid       (io_mmio_bvalid),
        .s_axi_bready       (io_mmio_bready),
        .s_axi_arid         (io_mmio_arid),
        .s_axi_araddr       (io_mmio_araddr),
        .s_axi_arlen        (io_mmio_arlen),
        .s_axi_arsize       (io_mmio_arsize),
        .s_axi_arburst      (io_mmio_arburst),
        .s_axi_arlock       (io_mmio_arlock),
        .s_axi_arcache      (io_mmio_arcache),
        .s_axi_arregion     (4'd0),
        .s_axi_arqos        (io_mmio_arqos),
        .s_axi_arprot       (io_mmio_arprot),
        .s_axi_arvalid      (io_mmio_arvalid),
        .s_axi_arready      (io_mmio_arready),
        .s_axi_rid          (io_mmio_rid),
        .s_axi_rdata        (io_mmio_rdata),
        .s_axi_rresp        (io_mmio_rresp),
        .s_axi_rlast        (io_mmio_rlast),
        .s_axi_rvalid       (io_mmio_rvalid),
        .s_axi_rready       (io_mmio_rready),
        .m_axil_awaddr      (mmio_axil_awaddr),
        .m_axil_awprot      (mmio_axil_awprot),
        .m_axil_awvalid     (mmio_axil_awvalid),
        .m_axil_awready     (mmio_axil_awready),
        .m_axil_wdata       (mmio_axil_wdata),
        .m_axil_wstrb       (mmio_axil_wstrb),
        .m_axil_wvalid      (mmio_axil_wvalid),
        .m_axil_wready      (mmio_axil_wready),
        .m_axil_bresp       (mmio_axil_bresp),
        .m_axil_bvalid      (mmio_axil_bvalid),
        .m_axil_bready      (mmio_axil_bready),
        .m_axil_araddr      (mmio_axil_araddr),
        .m_axil_arprot      (mmio_axil_arprot),
        .m_axil_arvalid     (mmio_axil_arvalid),
        .m_axil_arready     (mmio_axil_arready),
        .m_axil_rdata       (mmio_axil_rdata),
        .m_axil_rresp       (mmio_axil_rresp),
        .m_axil_rvalid      (mmio_axil_rvalid),
        .m_axil_rready      (mmio_axil_rready)
    );

    EmuRam #(
        .ADDR_WIDTH     (32),
        .DATA_WIDTH     (256),
        .ID_WIDTH       (1),
        .MEM_SIZE       (64'h80000000),
        .TIMING_TYPE    ("fixed")
    )
    u_rammodel (
        .clk            (clk),
        .rst            (rst),
        .s_axi_awready  (mem_noid_awready),
        .s_axi_awvalid  (mem_noid_awvalid),
        .s_axi_awaddr   ({1'd0, mem_noid_awaddr[30:0]}),
        .s_axi_awprot   (mem_noid_awprot),
        .s_axi_awid     (1'b0),
        .s_axi_awlen    (mem_noid_awlen),
        .s_axi_awsize   (mem_noid_awsize),
        .s_axi_awburst  (mem_noid_awburst),
        .s_axi_awlock   (mem_noid_awlock),
        .s_axi_awcache  (mem_noid_awcache),
        .s_axi_awqos    (mem_noid_awqos),
        .s_axi_wready   (mem_noid_wready),
        .s_axi_wvalid   (mem_noid_wvalid),
        .s_axi_wdata    (mem_noid_wdata),
        .s_axi_wstrb    (mem_noid_wstrb),
        .s_axi_wlast    (mem_noid_wlast),
        .s_axi_bready   (mem_noid_bready),
        .s_axi_bvalid   (mem_noid_bvalid),
        .s_axi_bresp    (mem_noid_bresp),
        .s_axi_bid      (),
        .s_axi_arready  (mem_noid_arready),
        .s_axi_arvalid  (mem_noid_arvalid),
        .s_axi_araddr   ({1'd0, mem_noid_araddr[30:0]}),
        .s_axi_arprot   (mem_noid_arprot),
        .s_axi_arid     (1'b0),
        .s_axi_arlen    (mem_noid_arlen),
        .s_axi_arsize   (mem_noid_arsize),
        .s_axi_arburst  (mem_noid_arburst),
        .s_axi_arlock   (mem_noid_arlock),
        .s_axi_arcache  (mem_noid_arcache),
        .s_axi_arqos    (mem_noid_arqos),
        .s_axi_rready   (mem_noid_rready),
        .s_axi_rvalid   (mem_noid_rvalid),
        .s_axi_rresp    (mem_noid_rresp),
        .s_axi_rdata    (mem_noid_rdata),
        .s_axi_rlast    (mem_noid_rlast),
        .s_axi_rid      ()
    );

    wire [31:0] m00_axil_awaddr;
    wire [2:0]  m00_axil_awprot;
    wire        m00_axil_awvalid;
    wire        m00_axil_awready;
    wire [31:0] m00_axil_wdata;
    wire [3:0]  m00_axil_wstrb;
    wire        m00_axil_wvalid;
    wire        m00_axil_wready;
    wire [1:0]  m00_axil_bresp;
    wire        m00_axil_bvalid;
    wire        m00_axil_bready;
    wire [31:0] m00_axil_araddr;
    wire [2:0]  m00_axil_arprot;
    wire        m00_axil_arvalid;
    wire        m00_axil_arready;
    wire [31:0] m00_axil_rdata;
    wire [1:0]  m00_axil_rresp;
    wire        m00_axil_rvalid;
    wire        m00_axil_rready;

    wire [31:0] m01_axil_awaddr;
    wire [2:0]  m01_axil_awprot;
    wire        m01_axil_awvalid;
    wire        m01_axil_awready;
    wire [31:0] m01_axil_wdata;
    wire [3:0]  m01_axil_wstrb;
    wire        m01_axil_wvalid;
    wire        m01_axil_wready;
    wire [1:0]  m01_axil_bresp;
    wire        m01_axil_bvalid;
    wire        m01_axil_bready;
    wire [31:0] m01_axil_araddr;
    wire [2:0]  m01_axil_arprot;
    wire        m01_axil_arvalid;
    wire        m01_axil_arready;
    wire [31:0] m01_axil_rdata;
    wire [1:0]  m01_axil_rresp;
    wire        m01_axil_rvalid;
    wire        m01_axil_rready;

    axil_interconnect_wrap_1x2 #(
        .DATA_WIDTH     (32),
        .ADDR_WIDTH     (32),
        .M00_BASE_ADDR  (32'h10000000),
        .M00_ADDR_WIDTH (32'd16),
        .M01_BASE_ADDR  (32'h30000000),
        .M01_ADDR_WIDTH (32'd16)
    ) axil_ic (
        .clk                (clk),
        .rst                (rst),
        .s00_axil_awaddr    (mmio_axil_awaddr),
        .s00_axil_awprot    (mmio_axil_awprot),
        .s00_axil_awvalid   (mmio_axil_awvalid),
        .s00_axil_awready   (mmio_axil_awready),
        .s00_axil_wdata     (mmio_axil_wdata),
        .s00_axil_wstrb     (mmio_axil_wstrb),
        .s00_axil_wvalid    (mmio_axil_wvalid),
        .s00_axil_wready    (mmio_axil_wready),
        .s00_axil_bresp     (mmio_axil_bresp),
        .s00_axil_bvalid    (mmio_axil_bvalid),
        .s00_axil_bready    (mmio_axil_bready),
        .s00_axil_araddr    (mmio_axil_araddr),
        .s00_axil_arprot    (mmio_axil_arprot),
        .s00_axil_arvalid   (mmio_axil_arvalid),
        .s00_axil_arready   (mmio_axil_arready),
        .s00_axil_rdata     (mmio_axil_rdata),
        .s00_axil_rresp     (mmio_axil_rresp),
        .s00_axil_rvalid    (mmio_axil_rvalid),
        .s00_axil_rready    (mmio_axil_rready),
        .m00_axil_awaddr    (m00_axil_awaddr),
        .m00_axil_awprot    (m00_axil_awprot),
        .m00_axil_awvalid   (m00_axil_awvalid),
        .m00_axil_awready   (m00_axil_awready),
        .m00_axil_wdata     (m00_axil_wdata),
        .m00_axil_wstrb     (m00_axil_wstrb),
        .m00_axil_wvalid    (m00_axil_wvalid),
        .m00_axil_wready    (m00_axil_wready),
        .m00_axil_bresp     (m00_axil_bresp),
        .m00_axil_bvalid    (m00_axil_bvalid),
        .m00_axil_bready    (m00_axil_bready),
        .m00_axil_araddr    (m00_axil_araddr),
        .m00_axil_arprot    (m00_axil_arprot),
        .m00_axil_arvalid   (m00_axil_arvalid),
        .m00_axil_arready   (m00_axil_arready),
        .m00_axil_rdata     (m00_axil_rdata),
        .m00_axil_rresp     (m00_axil_rresp),
        .m00_axil_rvalid    (m00_axil_rvalid),
        .m00_axil_rready    (m00_axil_rready),
        .m01_axil_awaddr    (m01_axil_awaddr),
        .m01_axil_awprot    (m01_axil_awprot),
        .m01_axil_awvalid   (m01_axil_awvalid),
        .m01_axil_awready   (m01_axil_awready),
        .m01_axil_wdata     (m01_axil_wdata),
        .m01_axil_wstrb     (m01_axil_wstrb),
        .m01_axil_wvalid    (m01_axil_wvalid),
        .m01_axil_wready    (m01_axil_wready),
        .m01_axil_bresp     (m01_axil_bresp),
        .m01_axil_bvalid    (m01_axil_bvalid),
        .m01_axil_bready    (m01_axil_bready),
        .m01_axil_araddr    (m01_axil_araddr),
        .m01_axil_arprot    (m01_axil_arprot),
        .m01_axil_arvalid   (m01_axil_arvalid),
        .m01_axil_arready   (m01_axil_arready),
        .m01_axil_rdata     (m01_axil_rdata),
        .m01_axil_rresp     (m01_axil_rresp),
        .m01_axil_rvalid    (m01_axil_rvalid),
        .m01_axil_rready    (m01_axil_rready)
    );

    bootrom u_bootrom (
        .clk                (clk),
        .rst                (rst),
        .s_axilite_awaddr   (m00_axil_awaddr),
        .s_axilite_awprot   (m00_axil_awprot),
        .s_axilite_awvalid  (m00_axil_awvalid),
        .s_axilite_awready  (m00_axil_awready),
        .s_axilite_wdata    (m00_axil_wdata),
        .s_axilite_wstrb    (m00_axil_wstrb),
        .s_axilite_wvalid   (m00_axil_wvalid),
        .s_axilite_wready   (m00_axil_wready),
        .s_axilite_bresp    (m00_axil_bresp),
        .s_axilite_bvalid   (m00_axil_bvalid),
        .s_axilite_bready   (m00_axil_bready),
        .s_axilite_araddr   (m00_axil_araddr),
        .s_axilite_arprot   (m00_axil_arprot),
        .s_axilite_arvalid  (m00_axil_arvalid),
        .s_axilite_arready  (m00_axil_arready),
        .s_axilite_rdata    (m00_axil_rdata),
        .s_axilite_rresp    (m00_axil_rresp),
        .s_axilite_rvalid   (m00_axil_rvalid),
        .s_axilite_rready   (m00_axil_rready)
    );

    EmuUart u_uart (
        .clk                (clk),
        .rst                (rst),
        .s_axilite_awaddr   (m01_axil_awaddr),
        .s_axilite_awprot   (m01_axil_awprot),
        .s_axilite_awvalid  (m01_axil_awvalid),
        .s_axilite_awready  (m01_axil_awready),
        .s_axilite_wdata    (m01_axil_wdata),
        .s_axilite_wstrb    (m01_axil_wstrb),
        .s_axilite_wvalid   (m01_axil_wvalid),
        .s_axilite_wready   (m01_axil_wready),
        .s_axilite_bresp    (m01_axil_bresp),
        .s_axilite_bvalid   (m01_axil_bvalid),
        .s_axilite_bready   (m01_axil_bready),
        .s_axilite_araddr   (m01_axil_araddr),
        .s_axilite_arprot   (m01_axil_arprot),
        .s_axilite_arvalid  (m01_axil_arvalid),
        .s_axilite_arready  (m01_axil_arready),
        .s_axilite_rdata    (m01_axil_rdata),
        .s_axilite_rresp    (m01_axil_rresp),
        .s_axilite_rvalid   (m01_axil_rvalid),
        .s_axilite_rready   (m01_axil_rready),
        .intr               (uart_intr)
    );

endmodule
