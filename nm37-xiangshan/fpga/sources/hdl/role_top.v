/* =========================================
* Top module wrapper of an accelerator role
*
* Author: Yisong Chang (changyisong@ict.ac.cn)
* Date: 29/01/2021
* Version: v0.0.1
*===========================================
*/

`timescale 10 ns / 1 ns

module role_top (
  input         aclk,
  input         aresetn,

  output [31:0] m_axi_io_araddr,
  output [1:0]  m_axi_io_arburst,
  output [3:0]  m_axi_io_arcache,
  output [7:0]  m_axi_io_arlen,
  output [0:0]  m_axi_io_arlock,
  output [2:0]  m_axi_io_arprot,
  output [3:0]  m_axi_io_arqos,
  input         m_axi_io_arready,
  output [2:0]	m_axi_io_arsize,
  output        m_axi_io_arvalid,
  output [31:0]	m_axi_io_awaddr,
  output [1:0]	m_axi_io_awburst,
  output [3:0]	m_axi_io_awcache,
  output [7:0]	m_axi_io_awlen,
  output [0:0]	m_axi_io_awlock,
  output [2:0]	m_axi_io_awprot,
  output [3:0]	m_axi_io_awqos,
  input         m_axi_io_awready,
  output [2:0]	m_axi_io_awsize,
  output        m_axi_io_awvalid,
  output        m_axi_io_bready,
  input  [1:0]  m_axi_io_bresp,
  input         m_axi_io_bvalid,
  input  [31:0] m_axi_io_rdata,
  input         m_axi_io_rlast,
  output        m_axi_io_rready,
  input  [1:0]  m_axi_io_rresp,
  input         m_axi_io_rvalid,
  output [31:0] m_axi_io_wdata,
  output        m_axi_io_wlast,
  input         m_axi_io_wready,
  output [3:0]  m_axi_io_wstrb,
  output        m_axi_io_wvalid,

  output [35:0] m_axi_mem_araddr,
  output [1:0]  m_axi_mem_arburst,
  output [3:0]  m_axi_mem_arcache,
  output [7:0]  m_axi_mem_arlen,
  output [0:0]  m_axi_mem_arlock,
  output [2:0]  m_axi_mem_arprot,
  output [3:0]  m_axi_mem_arqos,
  input         m_axi_mem_arready,
  output [2:0]	m_axi_mem_arsize,
  output        m_axi_mem_arvalid,
  output [35:0]	m_axi_mem_awaddr,
  output [1:0]	m_axi_mem_awburst,
  output [3:0]	m_axi_mem_awcache,
  output [7:0]	m_axi_mem_awlen,
  output [0:0]	m_axi_mem_awlock,
  output [2:0]	m_axi_mem_awprot,
  output [3:0]	m_axi_mem_awqos,
  input         m_axi_mem_awready,
  output [2:0]	m_axi_mem_awsize,
  output        m_axi_mem_awvalid,
  output        m_axi_mem_bready,
  input  [1:0]  m_axi_mem_bresp,
  input         m_axi_mem_bvalid,
  input  [511:0]m_axi_mem_rdata,
  input         m_axi_mem_rlast,
  output        m_axi_mem_rready,
  input  [1:0]  m_axi_mem_rresp,
  input         m_axi_mem_rvalid,
  output [511:0]m_axi_mem_wdata,
  output        m_axi_mem_wlast,
  input         m_axi_mem_wready,
  output [63:0] m_axi_mem_wstrb,
  output        m_axi_mem_wvalid,

  input  [19:0] s_axi_ctrl_araddr,
  input  [2:0]  s_axi_ctrl_arprot,
  output        s_axi_ctrl_arready,
  input         s_axi_ctrl_arvalid,
  input  [19:0] s_axi_ctrl_awaddr,
  input  [2:0]  s_axi_ctrl_awprot,
  output        s_axi_ctrl_awready,
  input         s_axi_ctrl_awvalid,
  input         s_axi_ctrl_bready,
  output [1:0]  s_axi_ctrl_bresp,
  output        s_axi_ctrl_bvalid,
  output [31:0] s_axi_ctrl_rdata,
  input         s_axi_ctrl_rready,
  output [1:0]  s_axi_ctrl_rresp,
  output        s_axi_ctrl_rvalid,
  input  [31:0] s_axi_ctrl_wdata,
  output        s_axi_ctrl_wready,
  input  [3:0]  s_axi_ctrl_wstrb,
  input         s_axi_ctrl_wvalid,

  input  [35:0] s_axi_dma_araddr,
  input  [1:0]  s_axi_dma_arburst,
  input  [3:0]  s_axi_dma_arcache,
  input  [7:0]  s_axi_dma_arlen,
  input  [0:0]  s_axi_dma_arlock,
  input  [2:0]  s_axi_dma_arprot,
  input  [3:0]  s_axi_dma_arqos,
  output        s_axi_dma_arready,
  input  [2:0]  s_axi_dma_arsize,
  input         s_axi_dma_arvalid,
  input  [35:0] s_axi_dma_awaddr,
  input  [1:0]  s_axi_dma_awburst,
  input  [3:0]  s_axi_dma_awcache,
  input  [7:0]  s_axi_dma_awlen,
  input  [0:0]  s_axi_dma_awlock,
  input  [2:0]  s_axi_dma_awprot,
  input  [3:0]  s_axi_dma_awqos,
  output        s_axi_dma_awready,
  input  [2:0]  s_axi_dma_awsize,
  input         s_axi_dma_awvalid,
  input         s_axi_dma_bready,
  output [1:0]  s_axi_dma_bresp,
  output        s_axi_dma_bvalid,
  output [127:0]s_axi_dma_rdata,
  output        s_axi_dma_rlast,
  input         s_axi_dma_rready,
  output [1:0]  s_axi_dma_rresp,
  output        s_axi_dma_rvalid,
  input  [127:0]s_axi_dma_wdata,
  input         s_axi_dma_wlast,
  output        s_axi_dma_wready,
  input  [15:0] s_axi_dma_wstrb,
  input         s_axi_dma_wvalid
);

  role role_i
    (.aclk(aclk),
    .aresetn(aresetn),
    .m_axi_io_araddr(m_axi_io_araddr),
    .m_axi_io_arburst(m_axi_io_arburst),
    .m_axi_io_arcache(m_axi_io_arcache),
    .m_axi_io_arlen(m_axi_io_arlen),
    .m_axi_io_arlock(m_axi_io_arlock),
    .m_axi_io_arprot(m_axi_io_arprot),
    .m_axi_io_arqos(m_axi_io_arqos),
    .m_axi_io_arready(m_axi_io_arready),
    .m_axi_io_arsize(m_axi_io_arsize),
    .m_axi_io_arvalid(m_axi_io_arvalid),
    .m_axi_io_awaddr(m_axi_io_awaddr),
    .m_axi_io_awburst(m_axi_io_awburst),
    .m_axi_io_awcache(m_axi_io_awcache),
    .m_axi_io_awlen(m_axi_io_awlen),
    .m_axi_io_awlock(m_axi_io_awlock),
    .m_axi_io_awprot(m_axi_io_awprot),
    .m_axi_io_awqos(m_axi_io_awqos),
    .m_axi_io_awready(m_axi_io_awready),
    .m_axi_io_awsize(m_axi_io_awsize),
    .m_axi_io_awvalid(m_axi_io_awvalid),
    .m_axi_io_bready(m_axi_io_bready),
    .m_axi_io_bresp(m_axi_io_bresp),
    .m_axi_io_bvalid(m_axi_io_bvalid),
    .m_axi_io_rdata(m_axi_io_rdata),
    .m_axi_io_rlast(m_axi_io_rlast),
    .m_axi_io_rready(m_axi_io_rready),
    .m_axi_io_rresp(m_axi_io_rresp),
    .m_axi_io_rvalid(m_axi_io_rvalid),
    .m_axi_io_wdata(m_axi_io_wdata),
    .m_axi_io_wlast(m_axi_io_wlast),
    .m_axi_io_wready(m_axi_io_wready),
    .m_axi_io_wstrb(m_axi_io_wstrb),
    .m_axi_io_wvalid(m_axi_io_wvalid),
    .m_axi_mem_araddr(m_axi_mem_araddr),
    .m_axi_mem_arburst(m_axi_mem_arburst),
    .m_axi_mem_arcache(m_axi_mem_arcache),
    .m_axi_mem_arlen(m_axi_mem_arlen),
    .m_axi_mem_arlock(m_axi_mem_arlock),
    .m_axi_mem_arprot(m_axi_mem_arprot),
    .m_axi_mem_arqos(m_axi_mem_arqos),
    .m_axi_mem_arready(m_axi_mem_arready),
    .m_axi_mem_arsize(m_axi_mem_arsize),
    .m_axi_mem_arvalid(m_axi_mem_arvalid),
    .m_axi_mem_awaddr(m_axi_mem_awaddr),
    .m_axi_mem_awburst(m_axi_mem_awburst),
    .m_axi_mem_awcache(m_axi_mem_awcache),
    .m_axi_mem_awlen(m_axi_mem_awlen),
    .m_axi_mem_awlock(m_axi_mem_awlock),
    .m_axi_mem_awprot(m_axi_mem_awprot),
    .m_axi_mem_awqos(m_axi_mem_awqos),
    .m_axi_mem_awready(m_axi_mem_awready),
    .m_axi_mem_awsize(m_axi_mem_awsize),
    .m_axi_mem_awvalid(m_axi_mem_awvalid),
    .m_axi_mem_bready(m_axi_mem_bready),
    .m_axi_mem_bresp(m_axi_mem_bresp),
    .m_axi_mem_bvalid(m_axi_mem_bvalid),
    .m_axi_mem_rdata(m_axi_mem_rdata),
    .m_axi_mem_rlast(m_axi_mem_rlast),
    .m_axi_mem_rready(m_axi_mem_rready),
    .m_axi_mem_rresp(m_axi_mem_rresp),
    .m_axi_mem_rvalid(m_axi_mem_rvalid),
    .m_axi_mem_wdata(m_axi_mem_wdata),
    .m_axi_mem_wlast(m_axi_mem_wlast),
    .m_axi_mem_wready(m_axi_mem_wready),
    .m_axi_mem_wstrb(m_axi_mem_wstrb),
    .m_axi_mem_wvalid(m_axi_mem_wvalid),
    .s_axi_ctrl_araddr(s_axi_ctrl_araddr),
    .s_axi_ctrl_arready(s_axi_ctrl_arready),
    .s_axi_ctrl_arvalid(s_axi_ctrl_arvalid),
    .s_axi_ctrl_awaddr(s_axi_ctrl_awaddr),
    .s_axi_ctrl_awready(s_axi_ctrl_awready),
    .s_axi_ctrl_awvalid(s_axi_ctrl_awvalid),
    .s_axi_ctrl_bready(s_axi_ctrl_bready),
    .s_axi_ctrl_bresp(s_axi_ctrl_bresp),
    .s_axi_ctrl_bvalid(s_axi_ctrl_bvalid),
    .s_axi_ctrl_rdata(s_axi_ctrl_rdata),
    .s_axi_ctrl_rready(s_axi_ctrl_rready),
    .s_axi_ctrl_rresp(s_axi_ctrl_rresp),
    .s_axi_ctrl_rvalid(s_axi_ctrl_rvalid),
    .s_axi_ctrl_wdata(s_axi_ctrl_wdata),
    .s_axi_ctrl_wready(s_axi_ctrl_wready),
    .s_axi_ctrl_wstrb(s_axi_ctrl_wstrb),
    .s_axi_ctrl_wvalid(s_axi_ctrl_wvalid),
    .s_axi_dma_araddr(s_axi_dma_araddr),
    .s_axi_dma_arburst(s_axi_dma_arburst),
    .s_axi_dma_arcache(s_axi_dma_arcache),
    .s_axi_dma_arlen(s_axi_dma_arlen),
    .s_axi_dma_arlock(s_axi_dma_arlock),
    .s_axi_dma_arprot(s_axi_dma_arprot),
    .s_axi_dma_arqos(s_axi_dma_arqos),
    .s_axi_dma_arready(s_axi_dma_arready),
    .s_axi_dma_arsize(s_axi_dma_arsize),
    .s_axi_dma_arvalid(s_axi_dma_arvalid),
    .s_axi_dma_awaddr(s_axi_dma_awaddr),
    .s_axi_dma_awburst(s_axi_dma_awburst),
    .s_axi_dma_awcache(s_axi_dma_awcache),
    .s_axi_dma_awlen(s_axi_dma_awlen),
    .s_axi_dma_awlock(s_axi_dma_awlock),
    .s_axi_dma_awprot(s_axi_dma_awprot),
    .s_axi_dma_awqos(s_axi_dma_awqos),
    .s_axi_dma_awready(s_axi_dma_awready),
    .s_axi_dma_awsize(s_axi_dma_awsize),
    .s_axi_dma_awvalid(s_axi_dma_awvalid),
    .s_axi_dma_bready(s_axi_dma_bready),
    .s_axi_dma_bresp(s_axi_dma_bresp),
    .s_axi_dma_bvalid(s_axi_dma_bvalid),
    .s_axi_dma_rdata(s_axi_dma_rdata),
    .s_axi_dma_rlast(s_axi_dma_rlast),
    .s_axi_dma_rready(s_axi_dma_rready),
    .s_axi_dma_rresp(s_axi_dma_rresp),
    .s_axi_dma_rvalid(s_axi_dma_rvalid),
    .s_axi_dma_wdata(s_axi_dma_wdata),
    .s_axi_dma_wlast(s_axi_dma_wlast),
    .s_axi_dma_wready(s_axi_dma_wready),
    .s_axi_dma_wstrb(s_axi_dma_wstrb),
    .s_axi_dma_wvalid(s_axi_dma_wvalid));
 
endmodule
