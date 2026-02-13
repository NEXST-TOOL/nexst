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
  set ps_wizard [ create_bd_cell -type ip -vlnv xilinx.com:ip:ps_wizard:1.0 ps_wizard ]
  set_property -dict [list \
    CONFIG.PS_PMC_CONFIG(PMC_SMAP_PERIPHERAL) {PRIMARY_ENABLE 1 IO 8_Bit} \
    CONFIG.PS_PMC_CONFIG(PS_SLR_ID) {0} \
    ] [get_bd_cells ps_wizard]

  # Create instance: DDR4 MIG (use CLKOUT1 as the DUT core clk)
  set ddr4_mig [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4_pl:1.0 ddr4_mig ]
  set_property -dict [list \
    CONFIG.DDR4_DATAWIDTH {72} \
    CONFIG.DDR4_FREQ_SEL {MEMORY_CLK_FROM_SYS_CLK} \
    CONFIG.DDR4_INPUTCLK_PERIOD_IP {5000} \
    CONFIG.DDR4_TCK_OP {1000} \
    CONFIG.DDR4_MEMORY_DEVICETYPE {SODIMMs} \
    CONFIG.DDR4_MEMORY_SPEEDGRADE {DDR4-3200AA(22-22-22)} \
    CONFIG.DDR4_RANK {2} \
    CONFIG.DDR4_CASLATENCY {19} \
    CONFIG.DDR4_CASWRITELATENCY {14} \
    CONFIG.DDR4_ROWADDRESSWIDTH {17} \
    CONFIG.DDR4_SLOT {Single} \
    CONFIG.DDR4_TCK {800} \
    CONFIG.DDR4_INPUTCLK_PERIOD {5000} \
    CONFIG.DDR4_READ_DBI {true} \
    ] [get_bd_cells ddr4_mig]

  # Create instance: PCIe Endpoint
  set qdma_ep [ create_bd_cell -type ip -vlnv xilinx.com:ip:qdma:5.1 qdma_ep ]
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
    CONFIG.pf0_pciebar2axibar_1 {0x0000000010000000} \
    CONFIG.pl_link_cap_max_link_speed {16.0_GT/s} \
    CONFIG.pl_link_cap_max_link_width {X8} \
    ] $qdma_ep

  # Create instance: qdma_ep_support
  create_hier_cell_qdma_ep_support [current_bd_instance .] qdma_ep_support

  # Create instance: AXI SmartConnect for QDMA EP to DDR4
  set axi_ic_ddr_mem_qdma_ep [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_ic_ddr_mem_qdma_ep ]
  set_property -dict [ list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {2} \
    CONFIG.NUM_CLKS {2} \
    CONFIG.ADVANCED_PROPERTIES { \
      __view__ { \
        timing { \
          M00_Buffer { \
            AR_SLR_PIPE 2 \
            R_SLR_PIPE 2 \
            AW_SLR_PIPE 2 \
            W_SLR_PIPE 2 \
            B_SLR_PIPE 2 \
          } \
          S00_Buffer { \
            AR_SLR_PIPE 2 \
            R_SLR_PIPE 2 \
            AW_SLR_PIPE 2 \
            W_SLR_PIPE 2 \
            B_SLR_PIPE 2 \
          } \
          S01_Buffer { \
            AR_SLR_PIPE 2 \
            R_SLR_PIPE 2 \
            AW_SLR_PIPE 2 \
            W_SLR_PIPE 2 \
            B_SLR_PIPE 2 \
          } \
        } \
      } \
    } \
    ] $axi_ic_ddr_mem_qdma_ep

  # Create instance: AXI SmartConnect for DDR4
  set axi_ic_ddr_mem [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_ic_ddr_mem ]
  set_property -dict [ list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {2} \
    CONFIG.NUM_CLKS {2} \
    ] $axi_ic_ddr_mem

  # Create instance: AXI SmartConnect for PCIe AXI-Lite BAR interface
  set axi_ic_ep_bar_axi_lite [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_ic_ep_bar_axi_lite ]
  set_property -dict [ list \
    CONFIG.NUM_MI {3} \
    CONFIG.NUM_SI {1} \
    CONFIG.NUM_CLKS {2} \
    ] $axi_ic_ep_bar_axi_lite

  # Create instance: AXI SmartConnect for Role MMIO
  set axi_ic_role_io [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_ic_role_io ]
  set_property -dict [ list \
    CONFIG.NUM_MI {3} \
    CONFIG.NUM_SI {1} \
    CONFIG.NUM_CLKS {2} \
    ] $axi_ic_role_io

  # Create instance: AXI SmartConnect for Boot ROM
  set axi_ic_bootrom [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_ic_bootrom ]
  set_property -dict [ list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {2} \
    ] $axi_ic_bootrom

  # Create instance: AXI UART Lite over PCIe for Host-side
  set host_uart [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 host_uart ]
  set_property -dict [ list CONFIG.C_BAUDRATE {115200} ] $host_uart

  # Create instance: AXI UART Lite for Role
  set role_uart [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 role_uart ]
  set_property -dict [ list CONFIG.C_BAUDRATE {115200} ] $role_uart

  # Create instance: Block memory generator for Boot ROM
  set bootrom_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:emb_mem_gen:1.0 bootrom_bram ]

  # Create instance: AXI BRAM controller for Boot ROM
  set bootrom_bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bootrom_bram_ctrl ]
  set_property -dict [ list CONFIG.SINGLE_PORT_BRAM {1} CONFIG.PROTOCOL {AXI4}] $bootrom_bram_ctrl

  # constant for ready signal
  set const_vcc [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 const_vcc ]
  set_property -dict [list CONFIG.CONST_WIDTH {1} \
    CONFIG.CONST_VAL {0x1} ] $const_vcc

  set const_gnd [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 const_gnd ]
  set_property -dict [list CONFIG.CONST_WIDTH {1} \
    CONFIG.CONST_VAL {0x0} ] $const_gnd

  #=============================================
  # Clock ports
  #=============================================

  # Global Differential reference clock
  set gclk [ create_bd_intf_port -mode slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 gclk ]
  set_property -dict [ list config.freq_hz {200000000} ] $gclk

  # Create instance: global clock buffer for gclk
  set gclk_ibufds [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 gclk_ibufds ]
  set_property CONFIG.C_BUF_TYPE {IBUFDS} $gclk_ibufds

  set gclk_bufg [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 gclk_bufg ]
  set_property CONFIG.C_BUF_TYPE {BUFG} $gclk_bufg

  # gt differential reference clock for pcie ep
  set pcie_ep_gt_ref_clk [ create_bd_intf_port -mode slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_ep_gt_ref_clk ]
  set_property -dict [ list config.freq_hz {100000000} ] $pcie_ep_gt_ref_clk

  # Create instance: DUT slow clock generation
  ## (located in SLR0)
  set dut_clk_gen [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wizard:1.0 dut_clk_gen]
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

  # Create instance: inverter of perstn from PCIe EP
  set ep_perst_gen [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilvector_logic:1.0 ep_perst_gen ]
  set_property -dict [ list CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} ] $ep_perst_gen

  set mig_aresetn_gen [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilvector_logic:1.0 mig_aresetn_gen ]
  set_property -dict [ list CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} ] $mig_aresetn_gen

  # Create instance: qdma AXI slow clk sync. reset generation
  create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 dut_rst_gen

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

  # AXI-IC of DDR4 MIG
  connect_bd_intf_net [get_bd_intf_pins ddr4_mig/DDR4_S_AXI] \
    [get_bd_intf_pins axi_ic_ddr_mem/M00_AXI]

  connect_bd_intf_net [get_bd_intf_pins axi_ic_ddr_mem_qdma_ep/M00_AXI] \
    [get_bd_intf_pins axi_ic_ddr_mem/S00_AXI]

  connect_bd_intf_net [get_bd_intf_pins qdma_ep/M_AXI_BRIDGE] \
    [get_bd_intf_pins axi_ic_ddr_mem_qdma_ep/S00_AXI]

  connect_bd_intf_net [get_bd_intf_pins qdma_ep/M_AXI] \
    [get_bd_intf_pins axi_ic_ddr_mem_qdma_ep/S01_AXI]

  # Role to DDR4
  connect_bd_intf_net [get_bd_intf_pins u_role/m_axi_mem] \
    [get_bd_intf_pins axi_ic_ddr_mem/S01_AXI]

  # AXI-IC of PCIe EP AXI Lite
  connect_bd_intf_net [get_bd_intf_pins qdma_ep/M_AXI_LITE] \
    [get_bd_intf_pins axi_ic_ep_bar_axi_lite/S00_AXI]

  # PCIe EP to Host-side UART
  connect_bd_intf_net [get_bd_intf_pins host_uart/S_AXI] \
    [get_bd_intf_pins axi_ic_ep_bar_axi_lite/M00_AXI]

  # PCIe EP to Role ctrl
  connect_bd_intf_net [get_bd_intf_pins u_role/s_axi_ctrl] \
    [get_bd_intf_pins axi_ic_ep_bar_axi_lite/M01_AXI]

  # PCIe EP to Boot ROM IC
  connect_bd_intf_net [get_bd_intf_pins axi_ic_bootrom/S01_AXI] \
    [get_bd_intf_pins axi_ic_ep_bar_axi_lite/M02_AXI]

  # AXI-IC of Role MMIO
  connect_bd_intf_net [get_bd_intf_pins u_role/m_axi_io] \
    [get_bd_intf_pins axi_ic_role_io/S00_AXI]

  # Role to UART
  connect_bd_intf_net [get_bd_intf_pins role_uart/S_AXI] \
    [get_bd_intf_pins axi_ic_role_io/M00_AXI]

  # Role to Boot ROM IC
  connect_bd_intf_net [get_bd_intf_pins axi_ic_bootrom/S00_AXI] \
    [get_bd_intf_pins axi_ic_role_io/M01_AXI]

  # Role to DDR4 MIG Ctrl
  connect_bd_intf_net [get_bd_intf_pins ddr4_mig/DDR4_S_AXI_CTRL] \
    [get_bd_intf_pins axi_ic_role_io/M02_AXI]

  # AXI-IC of Boot ROM
  connect_bd_intf_net [get_bd_intf_pins bootrom_bram_ctrl/S_AXI] \
    [get_bd_intf_pins axi_ic_bootrom/M00_AXI]

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

  # PCIe EP slot
  connect_bd_intf_net [get_bd_intf_ports pcie_ep] [get_bd_intf_pins qdma_ep_support/pcie_mgt]

  #==============================================
  # DDR4 memory connection
  #==============================================

  connect_bd_intf_net [get_bd_intf_pins ddr4_mig/DDR4] [get_bd_intf_ports c0_ddr4]

  #==============================================
  # MISC signals connection
  #==============================================

  # connect_bd_net [get_bd_pins qdma_ep/user_lnk_up] \
  #     [get_bd_pins pcie_ep_lnk_up]

  connect_bd_net [get_bd_pins host_uart/rx] \
    [get_bd_pins role_uart/tx]

  connect_bd_net [get_bd_pins host_uart/tx] \
    [get_bd_pins role_uart/rx]

  connect_bd_intf_net [get_bd_intf_pins bootrom_bram_ctrl/BRAM_PORTA] \
    [get_bd_intf_pins bootrom_bram/BRAM_PORTA]

  #=============================================
  # Interrupt signal connection
  #=============================================

  # Create intr_sync

  ## Role interrupts
  set role_intr_concat [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat:1.0 role_intr_concat ]
  set_property -dict [list \
    CONFIG.NUM_PORTS {15} \
    ] $role_intr_concat

  connect_bd_net [get_bd_pins role_uart/interrupt] [get_bd_pins role_intr_concat/In0]

  connect_bd_net [get_bd_pins role_intr_concat/dout] [get_bd_pins u_role/s2r_intr]

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
    [get_bd_intf_pins ddr4_mig/SYS_CLK]

  # DDR4 controller ui clock (300MHz) for AXI IC and AXI interface
  connect_bd_net [get_bd_pins ddr4_mig/ddr4_ui_clk] \
    [get_bd_pins axi_ic_ddr_mem/aclk1] \
    [get_bd_pins axi_ic_ddr_mem_qdma_ep/aclk1] \
    [get_bd_pins axi_ic_role_io/aclk1]

  # PCIe EP BAR interfaces (250MHz)
  connect_bd_net -net pcie_fast_clk [get_bd_pins qdma_ep/axi_aclk] \
    [get_bd_pins axi_ic_ep_bar_axi_lite/aclk1] \
    [get_bd_pins axi_ic_ddr_mem_qdma_ep/aclk]

  # Global clock
  connect_bd_intf_net [get_bd_intf_ports gclk] [get_bd_intf_pins gclk_ibufds/CLK_IN_D]
  connect_bd_net [get_bd_pins gclk_ibufds/IBUF_OUT] [get_bd_pins gclk_bufg/BUFG_I]
  connect_bd_net [get_bd_pins gclk_bufg/BUFG_O] [get_bd_pins dut_clk_gen/clk_in1]

  # slow clock (50MHz) generated from PCIe EP ui clock
  connect_bd_net -net pcie_slow_clk1 [get_bd_pins dut_clk_gen/clk_out1] \
    [get_bd_pins dut_rst_gen/slowest_sync_clk] \
    [get_bd_pins bootrom_bram_ctrl/s_axi_aclk] \
    [get_bd_pins axi_ic_bootrom/aclk] \
    [get_bd_pins host_uart/s_axi_aclk] \
    [get_bd_pins u_role/aclk] \
    [get_bd_pins axi_ic_ddr_mem/aclk] \
    [get_bd_pins axi_ic_role_io/aclk] \
    [get_bd_pins axi_ic_ep_bar_axi_lite/aclk] \
    [get_bd_pins role_uart/s_axi_aclk]

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
    [get_bd_pins dut_rst_gen/ext_reset_in]

  # System reset for PL DDR4 MIG (opposite polarity of PCIe EP perstn, active high)
  connect_bd_net -net pcie_ep_perstn [get_bd_pins ep_perst_gen/Op1]

  connect_bd_net [get_bd_pins ep_perst_gen/Res] [get_bd_pins ddr4_mig/sys_rst]

  connect_bd_net [get_bd_pins mig_aresetn_gen/Res] [get_bd_pins ddr4_mig/ddr4_aresetn]

  # Reset signals of the slow PCIe clock domain
  connect_bd_net [get_bd_pins dut_rst_gen/peripheral_aresetn] \
    [get_bd_pins u_role/aresetn] \
    [get_bd_pins role_uart/s_axi_aresetn] \
    [get_bd_pins bootrom_bram_ctrl/s_axi_aresetn] \
    [get_bd_pins axi_ic_bootrom/aresetn] \
    [get_bd_pins host_uart/s_axi_aresetn]

  connect_bd_net [get_bd_pins dut_rst_gen/interconnect_aresetn] \
    [get_bd_pins axi_ic_ddr_mem_qdma_ep/aresetn] \
    [get_bd_pins axi_ic_ep_bar_axi_lite/aresetn] \
    [get_bd_pins axi_ic_ddr_mem/aresetn] \
    [get_bd_pins axi_ic_role_io/aresetn]

  #=============================================
  # ILA
  #=============================================

  # Create instance: system_ila, and set properties
  set dut_ila [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_ila:1.3 dut_ila ]
  set_property -dict [ list \
    CONFIG.C_MON_TYPE {Interface_Monitor} \
    CONFIG.C_NUM_MONITOR_SLOTS {2} \
    ] $dut_ila

  connect_bd_net [get_bd_pins dut_clk_gen/clk_out1] [get_bd_pins dut_ila/clk]
  connect_bd_net [get_bd_pins dut_rst_gen/peripheral_aresetn] [get_bd_pins dut_ila/resetn]

  connect_bd_intf_net [get_bd_intf_pins dut_ila/SLOT_0_AXI] [get_bd_intf_pins u_role/m_axi_mem]
  connect_bd_intf_net [get_bd_intf_pins dut_ila/SLOT_1_AXI] [get_bd_intf_pins u_role/m_axi_io]

  set ddr_ila [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_ila:1.3 ddr_ila ]
  set_property -dict [list \
    CONFIG.C_MON_TYPE {Mixed} \
    CONFIG.C_NUM_MONITOR_SLOTS {2} \
    ] [get_bd_cells ddr_ila]

  connect_bd_net [get_bd_pins ddr4_mig/ddr4_ui_clk] [get_bd_pins ddr_ila/clk]
  connect_bd_net [get_bd_pins ddr4_mig/ddr4_ui_clk_sync_rst] [get_bd_pins mig_aresetn_gen/Op1]
  connect_bd_net [get_bd_pins mig_aresetn_gen/Res] [get_bd_pins ddr_ila/resetn]

  connect_bd_intf_net [get_bd_intf_pins ddr_ila/SLOT_0_AXI] [get_bd_intf_pins ddr4_mig/DDR4_S_AXI]
  connect_bd_intf_net [get_bd_intf_pins ddr_ila/SLOT_1_AXI] [get_bd_intf_pins ddr4_mig/DDR4_S_AXI_CTRL]

  connect_bd_net [get_bd_pins ddr_ila/probe0] [get_bd_pins ddr4_mig/init_calib_complete]

  set pcie_ila [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_ila:1.3 pcie_ila ]
  set_property -dict [list \
    CONFIG.C_MON_TYPE {Interface_Monitor} \
    CONFIG.C_NUM_MONITOR_SLOTS {3} \
    ] [get_bd_cells pcie_ila]

  connect_bd_net [get_bd_pins qdma_ep/axi_aclk] [get_bd_pins pcie_ila/clk]
  connect_bd_net [get_bd_pins qdma_ep/axi_aresetn] [get_bd_pins pcie_ila/resetn]

  connect_bd_intf_net [get_bd_intf_pins pcie_ila/SLOT_0_AXI] [get_bd_intf_pins qdma_ep/M_AXI]
  connect_bd_intf_net [get_bd_intf_pins pcie_ila/SLOT_1_AXI] [get_bd_intf_pins qdma_ep/M_AXI_LITE]
  connect_bd_intf_net [get_bd_intf_pins pcie_ila/SLOT_2_AXI] [get_bd_intf_pins qdma_ep/M_AXI_BRIDGE]

  set top_ila [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_ila:1.3 top_ila ]
  set_property -dict [list \
    CONFIG.C_NUM_OF_PROBES {4} \
    ] [get_bd_cells top_ila]
  connect_bd_net [get_bd_pins top_ila/clk] [get_bd_pins gclk_bufg/BUFG_O]
  connect_bd_net [get_bd_pins ddr4_mig/init_calib_complete] [get_bd_pins top_ila/probe0]
  connect_bd_net [get_bd_pins qdma_ep_support/phy_rdy_out] [get_bd_pins top_ila/probe1]
  connect_bd_net [get_bd_pins qdma_ep_support/user_lnk_up] [get_bd_pins top_ila/probe2]
  connect_bd_net [get_bd_pins dut_clk_gen/locked] [get_bd_pins top_ila/probe3]

  #=============================================
  # Address segments
  #=============================================

  ## PCIe EP address space
  create_bd_addr_seg -range 0x10000 -offset 0x10000000 [get_bd_addr_spaces qdma_ep/M_AXI_LITE] [get_bd_addr_segs bootrom_bram_ctrl/S_AXI/Mem0] PCIE_EP_BAR_BOOTROM
  create_bd_addr_seg -range 0x1000 -offset 0x10011000 [get_bd_addr_spaces qdma_ep/M_AXI_LITE] [get_bd_addr_segs host_uart/S_AXI/Reg] PCIE_EP_BAR_HOST_UART
  create_bd_addr_seg -range 0x100000 -offset 0x10100000 [get_bd_addr_spaces qdma_ep/M_AXI_LITE] [get_bd_addr_segs u_role/s_axi_ctrl/reg0] PCIE_EP_BAR_ROLE_CTRL
  create_bd_addr_seg -range 0x200000000 -offset 0x0 [get_bd_addr_spaces qdma_ep/M_AXI_BRIDGE] [get_bd_addr_segs ddr4_mig/DDR4_MEMORY_MAP/DDR4_ADDRESS_BLOCK] PCIE_EP_BAR_DDR

  ## Role address space
  create_bd_addr_seg -range 0x10000 -offset 0x10000000 [get_bd_addr_spaces u_role/m_axi_io] [get_bd_addr_segs bootrom_bram_ctrl/S_AXI/Mem0] ROLE_BOOTROM
  create_bd_addr_seg -range 0x10000 -offset 0x30000000 [get_bd_addr_spaces u_role/m_axi_io] [get_bd_addr_segs role_uart/S_AXI/Reg] ROLE_UART
  create_bd_addr_seg -range 0x10000 -offset 0x30010000 [get_bd_addr_spaces u_role/m_axi_io] [get_bd_addr_segs role_uart/S_AXI/Reg] ROLE_DDR4_CTRL
  create_bd_addr_seg -range 0x200000000 -offset 0x0 [get_bd_addr_spaces u_role/m_axi_mem] [get_bd_addr_segs ddr4_mig/DDR4_MEMORY_MAP/DDR4_ADDRESS_BLOCK] ROLE_DDR

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
