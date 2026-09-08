`timescale 1 ns / 1 ps

module axi_lite_jtag_bridge #(
  parameter integer C_S_AXI_DATA_WIDTH = 32,
  parameter integer C_S_AXI_ADDR_WIDTH = 12
) (
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI_ACLK, ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 50000000" *)
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 S_AXI_ACLK CLK" *)
  input  wire                              s_axi_aclk,
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI_ARESETN, POLARITY ACTIVE_LOW" *)
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 S_AXI_ARESETN RST" *)
  input  wire                              s_axi_aresetn,

  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWADDR" *)
  input  wire [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_awaddr,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWPROT" *)
  input  wire [2:0]                        s_axi_awprot,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *)
  input  wire                              s_axi_awvalid,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *)
  output wire                              s_axi_awready,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WDATA" *)
  input  wire [C_S_AXI_DATA_WIDTH-1:0]     s_axi_wdata,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *)
  input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0] s_axi_wstrb,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WVALID" *)
  input  wire                              s_axi_wvalid,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI WREADY" *)
  output wire                              s_axi_wready,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BRESP" *)
  output reg  [1:0]                        s_axi_bresp,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BVALID" *)
  output reg                               s_axi_bvalid,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI BREADY" *)
  input  wire                              s_axi_bready,

  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *)
  input  wire [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_araddr,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARPROT" *)
  input  wire [2:0]                        s_axi_arprot,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *)
  input  wire                              s_axi_arvalid,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *)
  output wire                              s_axi_arready,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RDATA" *)
  output reg  [C_S_AXI_DATA_WIDTH-1:0]     s_axi_rdata,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RRESP" *)
  output reg  [1:0]                        s_axi_rresp,
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RVALID" *)
  output reg                               s_axi_rvalid,
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXI, DATA_WIDTH 32, PROTOCOL AXI4LITE, ADDR_WIDTH 12, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1" *)
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S_AXI RREADY" *)
  input  wire                              s_axi_rready,

  output wire                              jtag_tck,
  output wire                              jtag_tms,
  output wire                              jtag_tdi,
  input  wire                              jtag_tdo_data,
  input  wire                              jtag_tdo_driven,
  output wire                              jtag_reset,
  output wire [10:0]                       jtag_mfr_id,
  output wire [15:0]                       jtag_part_number,
  output wire [3:0]                        jtag_version
);

  localparam [31:0] JTAG_BRIDGE_MAGIC = 32'h584a5447; // "XJTG"

  localparam [5:0] REG_CTRL    = 6'h00;
  localparam [5:0] REG_STATUS  = 6'h04;
  localparam [5:0] REG_MAGIC   = 6'h08;
  localparam [5:0] REG_IDCODE  = 6'h0c;
  localparam [5:0] REG_SCRATCH = 6'h10;

  reg [C_S_AXI_ADDR_WIDTH-1:0] awaddr_reg;
  reg [C_S_AXI_DATA_WIDTH-1:0] wdata_reg;
  reg [(C_S_AXI_DATA_WIDTH/8)-1:0] wstrb_reg;
  reg aw_pending;
  reg w_pending;

  reg [31:0] ctrl_reg;
  reg [31:0] idcode_reg;
  reg [31:0] scratch_reg;
  reg [31:0] pending_ctrl_reg;
  reg ctrl_rise_pending;

  wire [31:0] ctrl_write_value = apply_wstrb(ctrl_reg, wdata_reg, wstrb_reg) & 32'h0000000f;

  wire write_ready = aw_pending && w_pending && !s_axi_bvalid && !ctrl_rise_pending;

  assign s_axi_awready = !aw_pending && !s_axi_bvalid;
  assign s_axi_wready  = !w_pending && !s_axi_bvalid;
  assign s_axi_arready = !s_axi_rvalid;

  assign jtag_tck         = ctrl_reg[0];
  assign jtag_tms         = ctrl_reg[1];
  assign jtag_tdi         = ctrl_reg[2];
  assign jtag_reset       = ctrl_reg[3];
  assign jtag_mfr_id      = idcode_reg[10:0];
  assign jtag_part_number = idcode_reg[26:11];
  assign jtag_version     = idcode_reg[30:27];

  function [31:0] apply_wstrb;
    input [31:0] old_value;
    input [31:0] new_value;
    input [3:0]  strobe;
    integer i;
    begin
      apply_wstrb = old_value;
      for (i = 0; i < 4; i = i + 1) begin
        if (strobe[i]) begin
          apply_wstrb[i*8 +: 8] = new_value[i*8 +: 8];
        end
      end
    end
  endfunction

  function [31:0] read_reg;
    input [C_S_AXI_ADDR_WIDTH-1:0] addr;
    begin
      case (addr[5:0])
        REG_CTRL: begin
          read_reg = ctrl_reg;
        end
        REG_STATUS: begin
          read_reg = {
            20'b0,
            ctrl_reg[3:0],
            6'b0,
            jtag_tdo_driven,
            jtag_tdo_data
          };
        end
        REG_MAGIC: begin
          read_reg = JTAG_BRIDGE_MAGIC;
        end
        REG_IDCODE: begin
          read_reg = idcode_reg;
        end
        REG_SCRATCH: begin
          read_reg = scratch_reg;
        end
        default: begin
          read_reg = 32'b0;
        end
      endcase
    end
  endfunction

  always @(posedge s_axi_aclk) begin
    if (!s_axi_aresetn) begin
      awaddr_reg  <= {C_S_AXI_ADDR_WIDTH{1'b0}};
      wdata_reg   <= {C_S_AXI_DATA_WIDTH{1'b0}};
      wstrb_reg   <= {(C_S_AXI_DATA_WIDTH/8){1'b0}};
      aw_pending  <= 1'b0;
      w_pending   <= 1'b0;
      s_axi_bresp <= 2'b00;
      s_axi_bvalid <= 1'b0;
      s_axi_rdata <= {C_S_AXI_DATA_WIDTH{1'b0}};
      s_axi_rresp <= 2'b00;
      s_axi_rvalid <= 1'b0;
      ctrl_reg    <= 32'b0;
      idcode_reg  <= 32'b0;
      scratch_reg <= 32'b0;
      pending_ctrl_reg <= 32'b0;
      ctrl_rise_pending <= 1'b0;
    end else begin
      if (s_axi_awready && s_axi_awvalid) begin
        awaddr_reg <= s_axi_awaddr;
        aw_pending <= 1'b1;
      end

      if (s_axi_wready && s_axi_wvalid) begin
        wdata_reg <= s_axi_wdata;
        wstrb_reg <= s_axi_wstrb;
        w_pending <= 1'b1;
      end

      if (ctrl_rise_pending) begin
        ctrl_reg <= pending_ctrl_reg;
        ctrl_rise_pending <= 1'b0;
        s_axi_bresp <= 2'b00;
        s_axi_bvalid <= 1'b1;
      end else if (write_ready) begin
        case (awaddr_reg[5:0])
          REG_CTRL: begin
            pending_ctrl_reg <= ctrl_write_value;
            if (!ctrl_reg[0] && ctrl_write_value[0]) begin
              ctrl_reg <= {
                28'b0,
                ctrl_write_value[3:1],
                1'b0
              };
              ctrl_rise_pending <= 1'b1;
            end else begin
              ctrl_reg <= ctrl_write_value;
              s_axi_bresp <= 2'b00;
              s_axi_bvalid <= 1'b1;
            end
          end
          REG_IDCODE: begin
            idcode_reg <= apply_wstrb(idcode_reg, wdata_reg, wstrb_reg) & 32'h7fffffff;
            s_axi_bresp <= 2'b00;
            s_axi_bvalid <= 1'b1;
          end
          REG_SCRATCH: begin
            scratch_reg <= apply_wstrb(scratch_reg, wdata_reg, wstrb_reg);
            s_axi_bresp <= 2'b00;
            s_axi_bvalid <= 1'b1;
          end
          default: begin
            s_axi_bresp <= 2'b00;
            s_axi_bvalid <= 1'b1;
          end
        endcase
        aw_pending <= 1'b0;
        w_pending <= 1'b0;
      end else if (s_axi_bvalid && s_axi_bready) begin
        s_axi_bvalid <= 1'b0;
      end

      if (s_axi_arready && s_axi_arvalid) begin
        s_axi_rdata <= read_reg(s_axi_araddr);
        s_axi_rresp <= 2'b00;
        s_axi_rvalid <= 1'b1;
      end else if (s_axi_rvalid && s_axi_rready) begin
        s_axi_rvalid <= 1'b0;
      end
    end
  end

endmodule