#========================================================
# Vivado BD design auto run script for XiangShan wrapper
# on Xilinx VP1902
# Based on Vivado 2024.2
# Author: Shiqi Liu (liushiqi@ict.ac.cn)
# Date: 02/05/2026
#========================================================

namespace eval mpsoc_bd_val {
  set design_name xiangshan
  set bd_prefix ${mpsoc_bd_val::design_name}_
}

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${mpsoc_bd_val::design_name} eq "" } {
  # USE CASES:
  #    1) Design_name not set

  set errMsg "Please set the variable <design_name> to a non-empty value."
  set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
  # USE CASES:
  #    2): Current design opened AND is empty AND names same.
  #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
  #    4): Current design opened AND is empty AND names diff; design_name exists in project.

  if { $cur_design ne ${mpsoc_bd_val::design_name} } {
    common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <${mpsoc_bd_val::design_name}> to <$cur_design> since current design is empty."
    set design_name [get_property NAME $cur_design]
  }
  common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq ${mpsoc_bd_val::design_name} } {
  # USE CASES:
  #    5) Current design opened AND has components AND same names.

  set errMsg "Design <${mpsoc_bd_val::design_name}> already exists in your project, please set the variable <design_name> to another value."
  set nRet 1
} elseif { [get_files -quiet ${mpsoc_bd_val::design_name}.bd] ne "" } {
  # USE CASES:
  #    6) Current opened design, has components, but diff names, design_name exists in project.
  #    7) No opened design, design_name exists in project.

  set errMsg "Design <${mpsoc_bd_val::design_name}> already exists in your project, please set the variable <design_name> to another value."
  set nRet 2

} else {
  # USE CASES:
  #    8) No opened design, design_name not in project.
  #    9) Current opened design, has components, but diff names, design_name not in project.

  common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <${mpsoc_bd_val::design_name}> in project, so creating one..."

  create_bd_design ${mpsoc_bd_val::design_name}

  common::send_msg_id "BD_TCL-004" "INFO" "Making design <${mpsoc_bd_val::design_name}> as current_bd_design."
  current_bd_design ${mpsoc_bd_val::design_name}

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"${mpsoc_bd_val::design_name}\"."

if { $nRet != 0 } {
  catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
  return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################

# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
    set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
    catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
    return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
    catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
    return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  #=============================================
  # Create IP blocks
  #=============================================

  # Create instance: role_top
  set block_name role_top
  set block_cell_name u_role
  if { [catch {set u_role [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
    catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
    return 1
  } elseif { $u_role eq "" } {
    catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
    return 1
  }

  # Create ps wizard
  set ps_wizard [ create_bd_cell -type ip -vlnv xilinx.com:ip:ps_wizard ps_wizard ]
  set_property -dict [list \
    CONFIG.PS_PMC_CONFIG(PMC_SMAP_PERIPHERAL) {PRIMARY_ENABLE 1 IO 8_Bit} \
    CONFIG.PS_PMC_CONFIG(PS_SLR_ID) {0} \
    ] [get_bd_cells ps_wizard]

  # Create instance: PCIe Endpoint
  set qdma_ep [ create_bd_cell -type ip -vlnv xilinx.com:ip:qdma qdma_ep ]
  set_property -dict [list \
    CONFIG.axisten_freq {250} \
    CONFIG.csr_axilite_slave {false} \
    CONFIG.dma_intf_sel_qdma {AXI_MM} \
    CONFIG.enable_gtwizard {false} \
    CONFIG.functional_mode {QDMA} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.pcie_blk_locn {S0X0Y1} \
    CONFIG.pf0_bar0_64bit_qdma {false} \
    CONFIG.pf0_bar0_scale_qdma {Kilobytes} \
    CONFIG.pf0_bar0_size_qdma {256} \
    CONFIG.pf0_bar0_type_qdma {DMA} \
    CONFIG.pf0_bar1_enabled_qdma {true} \
    CONFIG.pf0_bar1_size_qdma {16} \
    CONFIG.pf0_bar1_type_qdma {AXI_Lite_Master} \
    CONFIG.pf0_bar2_enabled_qdma {true} \
    CONFIG.pf0_bar2_prefetchable_qdma {true} \
    CONFIG.pf0_bar2_scale_qdma {Gigabytes} \
    CONFIG.pf0_bar2_size_qdma {16} \
    CONFIG.pf0_bar2_type_qdma {AXI_Bridge_Master} \
    CONFIG.pf0_pciebar2axibar_1 {0x0000000000000000} \
    CONFIG.pl_link_cap_max_link_speed {16.0_GT/s} \
    CONFIG.pl_link_cap_max_link_width {X8} \
    ] $qdma_ep

  # Create instance: qdma_ep_support
  create_hier_cell_qdma_ep_support [current_bd_instance .] qdma_ep_support

  # Constants required by the QDMA support hierarchy.
  set const_vcc [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 const_vcc ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x1} \
    CONFIG.CONST_WIDTH {1} \
    ] $const_vcc

  set const_gnd [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 const_gnd ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x0} \
    CONFIG.CONST_WIDTH {1} \
    ] $const_gnd

  # Create DDR4 AXI NoC
  set axi_noc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.1 axi_noc_0 ]
  set_property -dict [list \
    CONFIG.MC_CASLATENCY {19} \
    CONFIG.MC_CASWRITELATENCY {14} \
    CONFIG.MC_CHAN_REGION0 {DDR_LOW1} \
    CONFIG.MC_DATAWIDTH {72} \
    CONFIG.MC_FREQ_SEL {MEMORY_CLK_FROM_SYS_CLK} \
    CONFIG.MC_IP_TIMEPERIOD0_FOR_OP {5000} \
    CONFIG.MC_MEMORY_DEVICETYPE {SODIMMs} \
    CONFIG.MC_MEMORY_SPEEDGRADE {DDR4-3200AA(22-22-22)} \
    CONFIG.MC_OP_TIMEPERIOD0 {1000} \
    CONFIG.MC_PRE_DEF_ADDR_MAP_SEL {ROW_BANK_COLUMN_BGO} \
    CONFIG.MC_RANK {2} \
    CONFIG.MC_READ_DBI {true} \
    CONFIG.MC_ROWADDRESSWIDTH {17} \
    CONFIG.MI_NAMES {} \
    CONFIG.NUM_CLKS {0} \
    CONFIG.NUM_MC {1} \
    CONFIG.NUM_MCP {1} \
    CONFIG.NUM_MI {0} \
    CONFIG.NUM_NSI {1} \
    CONFIG.NUM_SI {0} \
    CONFIG.SI_NAMES {} \
    CONFIG.SI_SIDEBAND_PINS {} \
    ] $axi_noc_0

  set_property -dict [list \
    CONFIG.CONNECTIONS {MC_0 {read_bw {16000} write_bw {16000} read_avg_burst {4} write_avg_burst {4} initial_boot {true}}} \
    ] [get_bd_intf_pins /axi_noc_0/S00_INI]

  # Create AXI NoC for QDMA and role traffic
  set axi_noc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_noc:1.1 axi_noc_1 ]
  set_property -dict [list \
    CONFIG.MI_NAMES {} \
    CONFIG.MI_SIDEBAND_PINS {} \
    CONFIG.NUM_CLKS {2} \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_NMI {1} \
    CONFIG.NUM_SI {4} \
    ] $axi_noc_1

  set_property -dict [list \
    CONFIG.APERTURES {{0x201_0000_0000 1G}} \
    CONFIG.CATEGORY {pl} \
    ] [get_bd_intf_pins /axi_noc_1/M00_AXI]

  set_property -dict [list \
    CONFIG.W_TRAFFIC_CLASS {BEST_EFFORT} \
    CONFIG.CONNECTIONS {M00_INI {read_bw {1000} write_bw {1000}}} \
    CONFIG.DEST_IDS {} \
    CONFIG.REMAPS {M00_INI {{0x0 0x08_0000_0000 0x800000000}}} \
    CONFIG.NOC_PARAMS {} \
    CONFIG.CATEGORY {pl} \
    ] [get_bd_intf_pins /axi_noc_1/S00_AXI]

  set_property -dict [list \
    CONFIG.CONNECTIONS {M00_INI {read_bw {8000} write_bw {8000}}} \
    CONFIG.DEST_IDS {} \
    CONFIG.REMAPS {M00_INI {{0x0 0x08_0000_0000 0x800000000}}} \
    CONFIG.NOC_PARAMS {} \
    CONFIG.CATEGORY {pl} \
    ] [get_bd_intf_pins /axi_noc_1/S01_AXI]

  set_property -dict [list \
    CONFIG.CONNECTIONS {M00_AXI {read_bw {1000} write_bw {1000} read_avg_burst {4} write_avg_burst {4}}} \
    CONFIG.DEST_IDS {M00_AXI:0x80} \
    CONFIG.REMAPS {M00_AXI {{0x0 0x0201_0000_0000 0x1000000}}} \
    CONFIG.NOC_PARAMS {} \
    CONFIG.CATEGORY {pl} \
    ] [get_bd_intf_pins /axi_noc_1/S02_AXI]

  set_property -dict [list \
    CONFIG.CONNECTIONS {M00_INI {read_bw {1000} write_bw {1000}}} \
    CONFIG.DEST_IDS {} \
    CONFIG.REMAPS {M00_INI {{0x00 0x8_0000_0000 0x800000000}}} \
    CONFIG.NOC_PARAMS {} \
    CONFIG.CATEGORY {pl} \
    ] [get_bd_intf_pins /axi_noc_1/S03_AXI]

  set_property -dict [list \
    CONFIG.ASSOCIATED_BUSIF {S00_AXI:S01_AXI:S02_AXI} \
    ] [get_bd_pins /axi_noc_1/aclk0]

  set_property -dict [list \
    CONFIG.ASSOCIATED_BUSIF {M00_AXI:S03_AXI} \
    ] [get_bd_pins /axi_noc_1/aclk1]

  # Convert the PCIe AXI-Lite BAR to AXI4 for the NoC.
  set axil_axi_adapter [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axil_axi_adapter ]
  set_property CONFIG.NUM_SI {1} $axil_axi_adapter

  # Convert the NoC AXI4 control path back to the role AXI-Lite port.
  set axi_axil_adapter [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_axil_adapter ]
  set_property CONFIG.NUM_SI {1} $axi_axil_adapter

  #=============================================
  # Clock ports
  #=============================================

  # Global Differential reference clock
  set gclk [ create_bd_intf_port -mode slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gclk ]
  set_property -dict [ list config.freq_hz {200000000} ] $gclk

  # Create instance: global clock buffer for gclk
  set gclk_ibufds [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf gclk_ibufds ]
  set_property CONFIG.C_BUF_TYPE {IBUFDS} $gclk_ibufds

  set gclk_bufg [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf gclk_bufg ]
  set_property CONFIG.C_BUF_TYPE {BUFG} $gclk_bufg

  # gt differential reference clock for pcie ep
  set pcie_ep_gt_ref_clk [ create_bd_intf_port -mode slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_ep_gt_ref_clk ]
  set_property -dict [ list config.freq_hz {100000000} ] $pcie_ep_gt_ref_clk

  # Create instance: DUT slow clock generation
  ## (located in SLR0)
  set dut_clk_gen [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard dut_clk_gen]
  set_property -dict [list \
    CONFIG.CLKOUT_REQUESTED_OUT_FREQUENCY {50,10} \
    CONFIG.CLKOUT_USED {true,true} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
    CONFIG.USE_LOCKED {true} \
    CONFIG.USE_RESET {true} \
    CONFIG.USE_SAFE_CLOCK_STARTUP {false} \
    ] $dut_clk_gen

  # Differential system clock for DDR4 MIG
  set ddr4_mig_sys_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr4_mig_sys_clk ]
  set_property -dict [ list CONFIG.FREQ_HZ {200000000} ] $ddr4_mig_sys_clk

  #=============================================
  # Reset ports
  #=============================================

  # PCIe EP perst
  create_bd_port -dir I -type rst pcie_ep_perstn


  # Create instance: qdma AXI slow clk sync. reset generation
  create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset dut_rst_gen

  #=============================================
  # GT ports
  #=============================================

  create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 pcie_ep

  #=============================================
  # DDR4 pins
  #=============================================

  create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 c0_ddr4

  #=============================================
  # MISC ports
  #=============================================
  ## DRAM calibration done
  #create_bd_port -dir O ddr4_mig_calib_done

  ## PCIe EP PHY ready and link up signals
  #create_bd_port -dir O pcie_ep_phy_ready
  #create_bd_port -dir O pcie_ep_lnk_up

  # Create QDMA interface connections
  connect_bd_intf_net [get_bd_intf_pins qdma_ep/pcie_cfg_control_if] \
    [get_bd_intf_pins qdma_ep_support/pcie_cfg_control]
  connect_bd_intf_net [get_bd_intf_pins qdma_ep/pcie_cfg_external_msix_without_msi_if] \
    [get_bd_intf_pins qdma_ep_support/pcie_cfg_external_msix_without_msi]
  connect_bd_intf_net [get_bd_intf_pins qdma_ep/pcie_cfg_interrupt] \
    [get_bd_intf_pins qdma_ep_support/pcie_cfg_interrupt]
  connect_bd_intf_net [get_bd_intf_pins qdma_ep/pcie_cfg_mgmt_if] \
    [get_bd_intf_pins qdma_ep_support/pcie_cfg_mgmt]
  connect_bd_intf_net [get_bd_intf_pins qdma_ep/s_axis_cc] \
    [get_bd_intf_pins qdma_ep_support/s_axis_cc]
  connect_bd_intf_net [get_bd_intf_pins qdma_ep/s_axis_rq] \
    [get_bd_intf_pins qdma_ep_support/s_axis_rq]
  connect_bd_intf_net [get_bd_intf_pins qdma_ep/m_axis_cq] \
    [get_bd_intf_pins qdma_ep_support/m_axis_cq]
  connect_bd_intf_net [get_bd_intf_pins qdma_ep/m_axis_rc] \
    [get_bd_intf_pins qdma_ep_support/m_axis_rc]
  connect_bd_intf_net [get_bd_intf_pins qdma_ep/pcie_cfg_fc] \
    [get_bd_intf_pins qdma_ep_support/pcie_cfg_fc]
  connect_bd_intf_net [get_bd_intf_pins qdma_ep/pcie_cfg_mesg_rcvd] \
    [get_bd_intf_pins qdma_ep_support/pcie_cfg_mesg_rcvd]
  connect_bd_intf_net [get_bd_intf_pins qdma_ep/pcie_cfg_mesg_tx] \
    [get_bd_intf_pins qdma_ep_support/pcie_cfg_mesg_tx]
  connect_bd_intf_net [get_bd_intf_pins qdma_ep/pcie_cfg_status_if] \
    [get_bd_intf_pins qdma_ep_support/pcie_cfg_status]
  connect_bd_intf_net [get_bd_intf_pins qdma_ep/pcie_transmit_fc_if] \
    [get_bd_intf_pins qdma_ep_support/pcie_transmit_fc]

  # Create QDMA port connections
  connect_bd_net [get_bd_pins const_vcc/dout] \
    [get_bd_pins qdma_ep_support/BUFG_GT_CE] \
    [get_bd_pins qdma_ep/soft_reset_n] \
    [get_bd_pins qdma_ep/tm_dsc_sts_rdy] \
    [get_bd_pins qdma_ep/qsts_out_rdy]
  connect_bd_net [get_bd_pins const_gnd/dout] [get_bd_pins qdma_ep_support/apb3clk]
  connect_bd_net [get_bd_pins qdma_ep_support/phy_rdy_out] [get_bd_pins qdma_ep/phy_rdy_out_sd]
  connect_bd_net [get_bd_pins qdma_ep_support/user_clk] [get_bd_pins qdma_ep/user_clk_sd]
  connect_bd_net [get_bd_pins qdma_ep_support/user_lnk_up] [get_bd_pins qdma_ep/user_lnk_up_sd]
  connect_bd_net [get_bd_pins qdma_ep_support/user_reset] [get_bd_pins qdma_ep/user_reset_sd]

  #=============================================
  # AXI interface connection
  #=============================================

  # PCIe and role traffic into the DDR NoC
  connect_bd_intf_net [get_bd_intf_pins axi_noc_1/M00_AXI] \
    [get_bd_intf_pins axi_axil_adapter/S00_AXI]
  connect_bd_intf_net [get_bd_intf_pins axi_noc_1/M00_INI] \
    [get_bd_intf_pins axi_noc_0/S00_INI]
  connect_bd_intf_net [get_bd_intf_pins qdma_ep/M_AXI] \
    [get_bd_intf_pins axi_noc_1/S00_AXI]
  connect_bd_intf_net [get_bd_intf_pins qdma_ep/M_AXI_BRIDGE] \
    [get_bd_intf_pins axi_noc_1/S01_AXI]
  connect_bd_intf_net [get_bd_intf_pins axil_axi_adapter/M00_AXI] \
    [get_bd_intf_pins axi_noc_1/S02_AXI]
  connect_bd_intf_net [get_bd_intf_pins u_role/m_axi_mem] \
    [get_bd_intf_pins axi_noc_1/S03_AXI]

  # PCIe AXI-Lite BAR to role control
  connect_bd_intf_net [get_bd_intf_pins qdma_ep/M_AXI_LITE] \
    [get_bd_intf_pins axil_axi_adapter/S00_AXI]
  connect_bd_intf_net [get_bd_intf_pins axi_axil_adapter/M00_AXI] \
    [get_bd_intf_pins u_role/s_axi_ctrl]

  #=============================================
  # AXI stream interface connection
  #=============================================

  # connect_bd_intf_net [get_bd_intf_pins role_decoupler/s_axis_trace] \
  #     [get_bd_intf_pins qdma_ep/S_AXIS_C2H_0]

  # connect_bd_net [get_bd_pins const_vcc/dout] \
  #     [get_bd_pins qdma_ep/m_axis_h2c_tready_0]

  #==============================================
  # GT Port connection
  #==============================================

  connect_bd_intf_net [get_bd_intf_ports pcie_ep] \
    [get_bd_intf_pins qdma_ep_support/pcie_mgt]

  #==============================================
  # DDR4 memory connection
  #==============================================

  connect_bd_intf_net [get_bd_intf_ports c0_ddr4] \
    [get_bd_intf_pins axi_noc_0/CH0_DDR4_0]

  #=============================================
  # System clock connection
  #=============================================

  # PCIe EP reference clock (250MHz)
  connect_bd_intf_net -intf_net pcie_ep_gt_ref_clk \
    [get_bd_intf_pins pcie_ep_gt_ref_clk] \
    [get_bd_intf_pins qdma_ep_support/pcie_refclk]

  # DDR4 memory controller reference clock (100MHz)
  connect_bd_intf_net -intf_net ddr4_mig_sys_clk_in \
    [get_bd_intf_pins ddr4_mig_sys_clk] \
    [get_bd_intf_pins axi_noc_0/sys_clk0]

  # Global clock
  connect_bd_intf_net [get_bd_intf_ports gclk] [get_bd_intf_pins gclk_ibufds/CLK_IN_D]
  connect_bd_net [get_bd_pins gclk_ibufds/IBUF_OUT] [get_bd_pins gclk_bufg/BUFG_I]
  connect_bd_net [get_bd_pins gclk_bufg/BUFG_O] [get_bd_pins dut_clk_gen/clk_in1]

  # PCIe AXI-Lite and NoC clocks
  connect_bd_net -net pcie_fast_clk [get_bd_pins qdma_ep/axi_aclk] \
    [get_bd_pins axi_noc_1/aclk0] \
    [get_bd_pins axil_axi_adapter/aclk]

  # Role and NoC clocks
  connect_bd_net -net pcie_slow_clk1 [get_bd_pins dut_clk_gen/clk_out1] \
    [get_bd_pins dut_rst_gen/slowest_sync_clk] \
    [get_bd_pins axi_noc_1/aclk1] \
    [get_bd_pins u_role/aclk] \
    [get_bd_pins axi_axil_adapter/aclk]
  connect_bd_net -net pcie_slow_clk2 [get_bd_pins dut_clk_gen/clk_out2] \
    [get_bd_pins u_role/rtc_clock]
  connect_bd_net [get_bd_pins dut_clk_gen/locked] \
    [get_bd_pins dut_rst_gen/dcm_locked]

  #=============================================
  # System reset connection
  #=============================================

  # perstn for AXI PCIe EP
  connect_bd_net -net pcie_ep_perstn [get_bd_ports pcie_ep_perstn] \
    [get_bd_pins qdma_ep_support/sys_reset]

  # reset for PCIe AXI clock domain
  connect_bd_net [get_bd_pins qdma_ep/axi_aresetn] \
    [get_bd_pins dut_clk_gen/resetn] \
    [get_bd_pins dut_rst_gen/ext_reset_in] \
    [get_bd_pins axil_axi_adapter/aresetn]

  # Reset signals of the slow PCIe clock domain
  connect_bd_net [get_bd_pins dut_rst_gen/peripheral_aresetn] \
    [get_bd_pins u_role/aresetn] \
    [get_bd_pins axi_axil_adapter/aresetn]

  #=============================================
  # Create address segments
  #=============================================

  assign_bd_address -offset 0x000800000000 -range 0x000800000000 \
    -target_address_space [get_bd_addr_spaces u_role/m_axi_mem] \
    [get_bd_addr_segs axi_noc_0/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000800000000 \
    -target_address_space [get_bd_addr_spaces qdma_ep/M_AXI] \
    [get_bd_addr_segs axi_noc_0/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x000800000000 -range 0x000800000000 \
    -target_address_space [get_bd_addr_spaces qdma_ep/M_AXI_BRIDGE] \
    [get_bd_addr_segs axi_noc_0/S00_INI/C0_DDR_LOW1] -force
  assign_bd_address -offset 0x0 -range 0x01000000 \
    -target_address_space [get_bd_addr_spaces qdma_ep/M_AXI_LITE] \
    [get_bd_addr_segs u_role/s_axi_ctrl/reg0] -force
  
  #=============================================
  # NoC Constraints
  #=============================================

  set_property -dict [list CONFIG.PHYSICAL_LOC {NOC_NSU512_S1X2Y6}] [get_bd_intf_pins /axi_noc_1/M00_AXI]
  set_property -dict [list CONFIG.PHYSICAL_LOC {NOC_NMU512_S1X2Y6}] [get_bd_intf_pins /axi_noc_1/S03_AXI]

  #=============================================
  # Finish BD creation
  #=============================================

  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

source ${design_dir}/../fpga/scripts/qdma_support.tcl

create_root_design ""
