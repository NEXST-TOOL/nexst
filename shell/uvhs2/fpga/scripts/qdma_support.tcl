
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
  proc get_script_folder {} {
    set script_path [file normalize [info script]]
    set script_folder [file dirname $script_path]
    return $script_folder
  }
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
  create_project project_1 myproj -part xcvp1902-vsva6865-3HP-e-S
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
  # USE CASES:
  #    1) Design_name not set

  set errMsg "Please set the variable <design_name> to a non-empty value."
  set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
  # USE CASES:
  #    2): Current design opened AND is empty AND names same.
  #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
  #    4): Current design opened AND is empty AND names diff; design_name exists in project.

  if { $cur_design ne $design_name } {
    common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
    set design_name [get_property NAME $cur_design]
  }
  common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
  # USE CASES:
  #    5) Current design opened AND has components AND same names.

  set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
  set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
  # USE CASES:
  #    6) Current opened design, has components, but diff names, design_name exists in project.
  #    7) No opened design, design_name exists in project.

  set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
  set nRet 2

} else {
  # USE CASES:
  #    8) No opened design, design_name not in project.
  #    9) Current opened design, has components, but diff names, design_name not in project.

  common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

  create_bd_design $design_name

  common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
  current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
  catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
  return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: qdma_ep_support
proc create_hier_cell_qdma_ep_support { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
    catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_qdma_ep_support() - Empty argument(s)!"}
    return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
    catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
    return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
    catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
    return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gt_rtl:1.0 pcie_mgt

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_refclk

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_cq

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_rc

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie_cfg_fc_rtl:1.1 pcie_cfg_fc

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:pcie3_cfg_interrupt_rtl:1.0 pcie_cfg_interrupt

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie3_cfg_msg_received_rtl:1.0 pcie_cfg_mesg_rcvd

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie3_cfg_mesg_tx_rtl:1.0 pcie_cfg_mesg_tx

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_cc

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_rq

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:pcie5_cfg_control_rtl:1.0 pcie_cfg_control

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:pcie4_cfg_msix_rtl:1.0 pcie_cfg_external_msix_without_msi

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:pcie4_cfg_mgmt_rtl:1.0 pcie_cfg_mgmt

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie5_cfg_status_rtl:1.0 pcie_cfg_status

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie3_transmit_fc_rtl:1.0 pcie_transmit_fc


  # Create pins
  create_bd_pin -dir I -type rst sys_reset
  create_bd_pin -dir I -from 0 -to 0 BUFG_GT_CE
  create_bd_pin -dir I -type clk apb3clk
  create_bd_pin -dir O phy_rdy_out
  create_bd_pin -dir O -type clk user_clk
  create_bd_pin -dir O user_lnk_up
  create_bd_pin -dir O -type rst user_reset

  # Create instance: pcie, and set properties
  set pcie [ create_bd_cell -type ip -vlnv xilinx.com:ip:pcie_versal:1.1 pcie ]
  set_property -dict [list \
    CONFIG.AXISTEN_IF_CQ_ALIGNMENT_MODE {Address_Aligned} \
    CONFIG.AXISTEN_IF_RQ_ALIGNMENT_MODE {DWORD_Aligned} \
    CONFIG.MSI_X_OPTIONS {MSI-X_External} \
    CONFIG.PF0_AER_CAP_ECRC_GEN_AND_CHECK_CAPABLE {false} \
    CONFIG.PF0_DEVICE_ID {B048} \
    CONFIG.PF0_INTERRUPT_PIN {INTA} \
    CONFIG.PF0_LINK_STATUS_SLOT_CLOCK_CONFIG {true} \
    CONFIG.PF0_MSIX_CAP_PBA_BIR {BAR_0} \
    CONFIG.PF0_MSIX_CAP_PBA_OFFSET {34000} \
    CONFIG.PF0_MSIX_CAP_TABLE_BIR {BAR_0} \
    CONFIG.PF0_MSIX_CAP_TABLE_OFFSET {30000} \
    CONFIG.PF0_MSIX_CAP_TABLE_SIZE {007} \
    CONFIG.PF0_REVISION_ID {00} \
    CONFIG.PF0_SRIOV_VF_DEVICE_ID {C048} \
    CONFIG.PF0_SUBSYSTEM_ID {0007} \
    CONFIG.PF0_SUBSYSTEM_VENDOR_ID {10EE} \
    CONFIG.PF0_Use_Class_Code_Lookup_Assistant {false} \
    CONFIG.PF1_DEVICE_ID {913F} \
    CONFIG.PF1_MSI_CAP_MULTIMSGCAP {1_vector} \
    CONFIG.PF1_REVISION_ID {00} \
    CONFIG.PF1_SUBSYSTEM_ID {0007} \
    CONFIG.PF1_SUBSYSTEM_VENDOR_ID {10EE} \
    CONFIG.PF1_Use_Class_Code_Lookup_Assistant {false} \
    CONFIG.PF2_DEVICE_ID {B248} \
    CONFIG.PF2_MSI_CAP_MULTIMSGCAP {1_vector} \
    CONFIG.PF2_REVISION_ID {00} \
    CONFIG.PF2_SUBSYSTEM_ID {0007} \
    CONFIG.PF2_SUBSYSTEM_VENDOR_ID {10EE} \
    CONFIG.PF2_Use_Class_Code_Lookup_Assistant {false} \
    CONFIG.PF3_DEVICE_ID {B348} \
    CONFIG.PF3_MSI_CAP_MULTIMSGCAP {1_vector} \
    CONFIG.PF3_REVISION_ID {00} \
    CONFIG.PF3_SUBSYSTEM_ID {0007} \
    CONFIG.PF3_SUBSYSTEM_VENDOR_ID {10EE} \
    CONFIG.PF3_Use_Class_Code_Lookup_Assistant {false} \
    CONFIG.PL_DISABLE_LANE_REVERSAL {TRUE} \
    CONFIG.PL_LINK_CAP_MAX_LINK_SPEED {16.0_GT/s} \
    CONFIG.PL_LINK_CAP_MAX_LINK_WIDTH {X8} \
    CONFIG.REF_CLK_FREQ {100_MHz} \
    CONFIG.SRIOV_CAP_ENABLE {false} \
    CONFIG.TL_PF_ENABLE_REG {1} \
    CONFIG.VFG0_MSIX_CAP_PBA_BIR {BAR_1:0} \
    CONFIG.VFG0_MSIX_CAP_PBA_OFFSET {4800} \
    CONFIG.VFG0_MSIX_CAP_TABLE_BIR {BAR_1:0} \
    CONFIG.VFG0_MSIX_CAP_TABLE_OFFSET {4000} \
    CONFIG.VFG0_MSIX_CAP_TABLE_SIZE {007} \
    CONFIG.VFG1_MSIX_CAP_TABLE_OFFSET {4000} \
    CONFIG.VFG2_MSIX_CAP_TABLE_OFFSET {4000} \
    CONFIG.VFG3_MSIX_CAP_TABLE_OFFSET {4000} \
    CONFIG.acs_ext_cap_enable {false} \
    CONFIG.all_speeds_all_sides {NO} \
    CONFIG.axisten_freq {250} \
    CONFIG.axisten_if_enable_client_tag {true} \
    CONFIG.axisten_if_enable_msg_route {1EFFF} \
    CONFIG.axisten_if_enable_msg_route_override {true} \
    CONFIG.axisten_if_width {512_bit} \
    CONFIG.cfg_ext_if {false} \
    CONFIG.cfg_mgmt_if {true} \
    CONFIG.copy_pf0 {true} \
    CONFIG.dedicate_perst {false} \
    CONFIG.device_port_type {PCI_Express_Endpoint_device} \
    CONFIG.en_dbg_descramble {false} \
    CONFIG.en_ext_clk {FALSE} \
    CONFIG.en_l23_entry {false} \
    CONFIG.en_parity {false} \
    CONFIG.en_transceiver_status_ports {false} \
    CONFIG.enable_auto_rxeq {False} \
    CONFIG.enable_ccix {FALSE} \
    CONFIG.enable_code {0000} \
    CONFIG.enable_dvsec {FALSE} \
    CONFIG.enable_gen4 {true} \
    CONFIG.enable_gtwizard {false} \
    CONFIG.enable_ibert {false} \
    CONFIG.enable_jtag_dbg {false} \
    CONFIG.enable_more_clk {false} \
    CONFIG.ext_pcie_cfg_space_enabled {false} \
    CONFIG.extended_tag_field {true} \
    CONFIG.insert_cips {false} \
    CONFIG.lane_order {Bottom} \
    CONFIG.legacy_ext_pcie_cfg_space_enabled {false} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.pcie_blk_locn {S0X0Y1} \
    CONFIG.pcie_link_debug {false} \
    CONFIG.pcie_link_debug_axi4_st {false} \
    CONFIG.pf0_ari_enabled {false} \
    CONFIG.pf0_bar0_64bit {false} \
    CONFIG.pf0_bar0_enabled {true} \
    CONFIG.pf0_bar0_scale {Kilobytes} \
    CONFIG.pf0_bar0_size {256} \
    CONFIG.pf0_bar1_64bit {false} \
    CONFIG.pf0_bar1_enabled {true} \
    CONFIG.pf0_bar1_scale {Megabytes} \
    CONFIG.pf0_bar1_size {16} \
    CONFIG.pf0_bar2_64bit {true} \
    CONFIG.pf0_bar2_enabled {true} \
    CONFIG.pf0_bar2_prefetchable {true} \
    CONFIG.pf0_bar2_scale {Gigabytes} \
    CONFIG.pf0_bar2_size {16} \
    CONFIG.pf0_bar4_enabled {false} \
    CONFIG.pf0_bar5_enabled {false} \
    CONFIG.pf0_base_class_menu {Memory_controller} \
    CONFIG.pf0_class_code_base {05} \
    CONFIG.pf0_class_code_interface {00} \
    CONFIG.pf0_class_code_sub {80} \
    CONFIG.pf0_expansion_rom_enabled {false} \
    CONFIG.pf0_msi_enabled {false} \
    CONFIG.pf0_msix_enabled {true} \
    CONFIG.pf0_sriov_bar0_64bit {true} \
    CONFIG.pf0_sriov_bar0_enabled {true} \
    CONFIG.pf0_sriov_bar0_prefetchable {true} \
    CONFIG.pf0_sriov_bar0_scale {Kilobytes} \
    CONFIG.pf0_sriov_bar0_size {32} \
    CONFIG.pf0_sriov_bar2_64bit {true} \
    CONFIG.pf0_sriov_bar2_enabled {true} \
    CONFIG.pf0_sriov_bar2_prefetchable {true} \
    CONFIG.pf0_sriov_bar2_scale {Kilobytes} \
    CONFIG.pf0_sriov_bar2_size {4} \
    CONFIG.pf0_sriov_bar4_enabled {false} \
    CONFIG.pf0_sriov_bar5_enabled {false} \
    CONFIG.pf0_sriov_bar5_prefetchable {false} \
    CONFIG.pf0_sub_class_interface_menu {Other_memory_controller} \
    CONFIG.pf1_base_class_menu {Memory_controller} \
    CONFIG.pf1_class_code_base {05} \
    CONFIG.pf1_class_code_interface {00} \
    CONFIG.pf1_class_code_sub {80} \
    CONFIG.pf1_msix_enabled {false} \
    CONFIG.pf1_sriov_bar5_prefetchable {false} \
    CONFIG.pf1_sub_class_interface_menu {Other_memory_controller} \
    CONFIG.pf1_vendor_id {10EE} \
    CONFIG.pf2_base_class_menu {Memory_controller} \
    CONFIG.pf2_class_code_base {05} \
    CONFIG.pf2_class_code_interface {00} \
    CONFIG.pf2_class_code_sub {80} \
    CONFIG.pf2_msix_enabled {false} \
    CONFIG.pf2_sriov_bar5_prefetchable {false} \
    CONFIG.pf2_sub_class_interface_menu {Other_memory_controller} \
    CONFIG.pf2_vendor_id {10EE} \
    CONFIG.pf3_base_class_menu {Memory_controller} \
    CONFIG.pf3_class_code_base {05} \
    CONFIG.pf3_class_code_interface {00} \
    CONFIG.pf3_class_code_sub {80} \
    CONFIG.pf3_msix_enabled {false} \
    CONFIG.pf3_sriov_bar5_prefetchable {false} \
    CONFIG.pf3_sub_class_interface_menu {Other_memory_controller} \
    CONFIG.pf3_vendor_id {10EE} \
    CONFIG.pipe_line_stage {2} \
    CONFIG.pipe_sim {false} \
    CONFIG.replace_uram_with_bram {false} \
    CONFIG.sys_reset_polarity {ACTIVE_LOW} \
    CONFIG.vendor_id {10EE} \
    CONFIG.warm_reboot_sbr_fix {false} \
    CONFIG.xlnx_ref_board {None} \
    ] $pcie


  # Create instance: pcie_phy, and set properties
  set pcie_phy [ create_bd_cell -type ip -vlnv xilinx.com:ip:pcie_phy_versal:1.1 pcie_phy ]
  set_property -dict [list \
    CONFIG.PL_LINK_CAP_MAX_LINK_SPEED {16.0_GT/s} \
    CONFIG.PL_LINK_CAP_MAX_LINK_WIDTH {X8} \
    CONFIG.aspm {No_ASPM} \
    CONFIG.async_mode {SRNS} \
    CONFIG.datapath_reorder {false} \
    CONFIG.disable_double_pipe {YES} \
    CONFIG.en_gt_pclk {false} \
    CONFIG.enable_gtwizard {false} \
    CONFIG.ins_loss_profile {Add-in_Card} \
    CONFIG.lane_order {Bottom} \
    CONFIG.lane_reversal {false} \
    CONFIG.phy_async_en {true} \
    CONFIG.phy_coreclk_freq {500_MHz} \
    CONFIG.phy_refclk_freq {100_MHz} \
    CONFIG.phy_userclk_freq {250_MHz} \
    CONFIG.pipeline_stages {2} \
    CONFIG.sim_model {NO} \
    CONFIG.tx_preset {4} \
    ] $pcie_phy


  # Create instance: bufg_gt_sysclk, and set properties
  set bufg_gt_sysclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 bufg_gt_sysclk ]
  set_property -dict [list \
    CONFIG.C_BUFG_GT_SYNC {true} \
    CONFIG.C_BUF_TYPE {BUFG_GT} \
    ] $bufg_gt_sysclk


  # Create instance: refclk_ibuf, and set properties
  set refclk_ibuf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 refclk_ibuf ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $refclk_ibuf


  # Create instance: gt_quad_0, and set properties
  set gt_quad_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_quad_base:1.1 gt_quad_0 ]
  set_property -dict [list \
    CONFIG.GT_TYPE {GTYP} \
    CONFIG.PORTS_INFO_DICT {LANE_SEL_DICT {PROT0 {RX0 RX1 RX2 RX3 TX0 TX1 TX2 TX3}} GT_TYPE GTYP REG_CONF_INTF APB3_INTF BOARD_PARAMETER { }} \
    CONFIG.REFCLK_STRING {HSCLK0_LCPLLGTREFCLK0 refclk_PROT0_R0_156.25_MHz_unique1 HSCLK1_LCPLLGTREFCLK0 refclk_PROT0_R0_156.25_MHz_unique1} \
    ] $gt_quad_0


  # Create instance: gt_quad_1, and set properties
  set gt_quad_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gt_quad_base:1.1 gt_quad_1 ]
  set_property -dict [list \
    CONFIG.GT_TYPE {GTYP} \
    CONFIG.PORTS_INFO_DICT {LANE_SEL_DICT {PROT0 {RX0 RX1 RX2 RX3 TX0 TX1 TX2 TX3}} GT_TYPE GTYP REG_CONF_INTF APB3_INTF BOARD_PARAMETER { }} \
    CONFIG.REFCLK_STRING {HSCLK0_LCPLLGTREFCLK0 refclk_PROT0_R0_156.25_MHz_unique1 HSCLK1_LCPLLGTREFCLK0 refclk_PROT0_R0_156.25_MHz_unique1} \
    ] $gt_quad_1


  # Create interface connections
  connect_bd_intf_net [get_bd_intf_pins refclk_ibuf/CLK_IN_D] [get_bd_intf_pins pcie_refclk]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/pcie_mgt] [get_bd_intf_pins pcie_mgt]
  connect_bd_intf_net [get_bd_intf_pins pcie/m_axis_cq] [get_bd_intf_pins m_axis_cq]
  connect_bd_intf_net [get_bd_intf_pins pcie/m_axis_rc] [get_bd_intf_pins m_axis_rc]
  connect_bd_intf_net [get_bd_intf_pins pcie/pcie_cfg_fc] [get_bd_intf_pins pcie_cfg_fc]
  connect_bd_intf_net [get_bd_intf_pins pcie/pcie_cfg_interrupt] [get_bd_intf_pins pcie_cfg_interrupt]
  connect_bd_intf_net [get_bd_intf_pins pcie/pcie_cfg_mesg_rcvd] [get_bd_intf_pins pcie_cfg_mesg_rcvd]
  connect_bd_intf_net [get_bd_intf_pins pcie/pcie_cfg_mesg_tx] [get_bd_intf_pins pcie_cfg_mesg_tx]
  connect_bd_intf_net [get_bd_intf_pins pcie/s_axis_cc] [get_bd_intf_pins s_axis_cc]
  connect_bd_intf_net [get_bd_intf_pins pcie/s_axis_rq] [get_bd_intf_pins s_axis_rq]
  connect_bd_intf_net [get_bd_intf_pins pcie/pcie_cfg_control] [get_bd_intf_pins pcie_cfg_control]
  connect_bd_intf_net [get_bd_intf_pins pcie/pcie_cfg_external_msix_without_msi] [get_bd_intf_pins pcie_cfg_external_msix_without_msi]
  connect_bd_intf_net [get_bd_intf_pins pcie/pcie_cfg_mgmt] [get_bd_intf_pins pcie_cfg_mgmt]
  connect_bd_intf_net [get_bd_intf_pins pcie/pcie_cfg_status] [get_bd_intf_pins pcie_cfg_status]
  connect_bd_intf_net [get_bd_intf_pins pcie/pcie_transmit_fc] [get_bd_intf_pins pcie_transmit_fc]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT_BUFGT] [get_bd_intf_pins gt_quad_0/GT0_BUFGT]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT0_Serial] [get_bd_intf_pins gt_quad_0/GT_Serial]
  connect_bd_intf_net [get_bd_intf_pins gt_quad_1/GT_NORTHIN_SOUTHOUT] [get_bd_intf_pins gt_quad_0/GT_NORTHOUT_SOUTHIN]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT1_Serial] [get_bd_intf_pins gt_quad_1/GT_Serial]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT_RX0] [get_bd_intf_pins gt_quad_0/RX0_GT_IP_Interface]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT_RX1] [get_bd_intf_pins gt_quad_0/RX1_GT_IP_Interface]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT_RX2] [get_bd_intf_pins gt_quad_0/RX2_GT_IP_Interface]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT_RX3] [get_bd_intf_pins gt_quad_0/RX3_GT_IP_Interface]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT_RX4] [get_bd_intf_pins gt_quad_1/RX0_GT_IP_Interface]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT_RX5] [get_bd_intf_pins gt_quad_1/RX1_GT_IP_Interface]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT_RX6] [get_bd_intf_pins gt_quad_1/RX2_GT_IP_Interface]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT_RX7] [get_bd_intf_pins gt_quad_1/RX3_GT_IP_Interface]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT_TX0] [get_bd_intf_pins gt_quad_0/TX0_GT_IP_Interface]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT_TX1] [get_bd_intf_pins gt_quad_0/TX1_GT_IP_Interface]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT_TX2] [get_bd_intf_pins gt_quad_0/TX2_GT_IP_Interface]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT_TX3] [get_bd_intf_pins gt_quad_0/TX3_GT_IP_Interface]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT_TX4] [get_bd_intf_pins gt_quad_1/TX0_GT_IP_Interface]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT_TX5] [get_bd_intf_pins gt_quad_1/TX1_GT_IP_Interface]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT_TX6] [get_bd_intf_pins gt_quad_1/TX2_GT_IP_Interface]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/GT_TX7] [get_bd_intf_pins gt_quad_1/TX3_GT_IP_Interface]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/gt_rxmargin_q0] [get_bd_intf_pins gt_quad_0/gt_rxmargin_intf]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/gt_rxmargin_q1] [get_bd_intf_pins gt_quad_1/gt_rxmargin_intf]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/phy_mac_rx] [get_bd_intf_pins pcie/phy_mac_rx]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/phy_mac_tx] [get_bd_intf_pins pcie/phy_mac_tx]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/phy_mac_command] [get_bd_intf_pins pcie/phy_mac_command]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/phy_mac_rx_margining] [get_bd_intf_pins pcie/phy_mac_rx_margining]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/phy_mac_status] [get_bd_intf_pins pcie/phy_mac_status]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/phy_mac_tx_drive] [get_bd_intf_pins pcie/phy_mac_tx_drive]
  connect_bd_intf_net [get_bd_intf_pins pcie_phy/phy_mac_tx_eq] [get_bd_intf_pins pcie/phy_mac_tx_eq]

  # Create port connections
  connect_bd_net [get_bd_pins BUFG_GT_CE] [get_bd_pins bufg_gt_sysclk/BUFG_GT_CE]
  connect_bd_net [get_bd_pins apb3clk] \
    [get_bd_pins gt_quad_0/apb3clk] \
    [get_bd_pins gt_quad_1/apb3clk]
  connect_bd_net [get_bd_pins bufg_gt_sysclk/BUFG_GT_O] \
    [get_bd_pins pcie_phy/phy_refclk] \
    [get_bd_pins pcie/sys_clk]
  connect_bd_net [get_bd_pins gt_quad_0/ch0_phyready] [get_bd_pins pcie_phy/ch0_phyready]
  connect_bd_net [get_bd_pins gt_quad_0/ch0_phystatus] [get_bd_pins pcie_phy/ch0_phystatus]
  connect_bd_net [get_bd_pins gt_quad_0/ch0_rxoutclk] [get_bd_pins pcie_phy/gt_rxoutclk]
  connect_bd_net [get_bd_pins gt_quad_0/ch0_txoutclk] [get_bd_pins pcie_phy/gt_txoutclk]
  connect_bd_net [get_bd_pins gt_quad_0/ch1_phyready] [get_bd_pins pcie_phy/ch1_phyready]
  connect_bd_net [get_bd_pins gt_quad_0/ch1_phystatus] [get_bd_pins pcie_phy/ch1_phystatus]
  connect_bd_net [get_bd_pins gt_quad_0/ch2_phyready] [get_bd_pins pcie_phy/ch2_phyready]
  connect_bd_net [get_bd_pins gt_quad_0/ch2_phystatus] [get_bd_pins pcie_phy/ch2_phystatus]
  connect_bd_net [get_bd_pins gt_quad_0/ch3_phyready] [get_bd_pins pcie_phy/ch3_phyready]
  connect_bd_net [get_bd_pins gt_quad_0/ch3_phystatus] [get_bd_pins pcie_phy/ch3_phystatus]
  connect_bd_net [get_bd_pins gt_quad_1/ch0_phyready] [get_bd_pins pcie_phy/ch4_phyready]
  connect_bd_net [get_bd_pins gt_quad_1/ch0_phystatus] [get_bd_pins pcie_phy/ch4_phystatus]
  connect_bd_net [get_bd_pins gt_quad_1/ch1_phyready] [get_bd_pins pcie_phy/ch5_phyready]
  connect_bd_net [get_bd_pins gt_quad_1/ch1_phystatus] [get_bd_pins pcie_phy/ch5_phystatus]
  connect_bd_net [get_bd_pins gt_quad_1/ch2_phyready] [get_bd_pins pcie_phy/ch6_phyready]
  connect_bd_net [get_bd_pins gt_quad_1/ch2_phystatus] [get_bd_pins pcie_phy/ch6_phystatus]
  connect_bd_net [get_bd_pins gt_quad_1/ch3_phyready] [get_bd_pins pcie_phy/ch7_phyready]
  connect_bd_net [get_bd_pins gt_quad_1/ch3_phystatus] [get_bd_pins pcie_phy/ch7_phystatus]
  connect_bd_net [get_bd_pins pcie/pcie_ltssm_state] [get_bd_pins pcie_phy/pcie_ltssm_state]
  connect_bd_net [get_bd_pins pcie_phy/gt_pcieltssm] \
    [get_bd_pins gt_quad_0/pcieltssm] \
    [get_bd_pins gt_quad_1/pcieltssm]
  connect_bd_net [get_bd_pins pcie_phy/gtrefclk] \
    [get_bd_pins gt_quad_0/GT_REFCLK0] \
    [get_bd_pins gt_quad_1/GT_REFCLK0]
  connect_bd_net -net pcie_phy_pcierstb  [get_bd_pins pcie_phy/pcierstb] \
    [get_bd_pins gt_quad_0/ch0_pcierstb] \
    [get_bd_pins gt_quad_0/ch1_pcierstb] \
    [get_bd_pins gt_quad_0/ch2_pcierstb] \
    [get_bd_pins gt_quad_0/ch3_pcierstb] \
    [get_bd_pins gt_quad_1/ch0_pcierstb] \
    [get_bd_pins gt_quad_1/ch1_pcierstb] \
    [get_bd_pins gt_quad_1/ch2_pcierstb] \
    [get_bd_pins gt_quad_1/ch3_pcierstb]
  connect_bd_net [get_bd_pins pcie_phy/phy_coreclk] [get_bd_pins pcie/phy_coreclk]
  connect_bd_net [get_bd_pins pcie_phy/phy_mcapclk] [get_bd_pins pcie/phy_mcapclk]
  connect_bd_net [get_bd_pins pcie_phy/phy_pclk] \
    [get_bd_pins pcie/phy_pclk] \
    [get_bd_pins gt_quad_0/ch0_txusrclk] \
    [get_bd_pins gt_quad_0/ch1_txusrclk] \
    [get_bd_pins gt_quad_0/ch2_txusrclk] \
    [get_bd_pins gt_quad_0/ch3_txusrclk] \
    [get_bd_pins gt_quad_1/ch0_txusrclk] \
    [get_bd_pins gt_quad_1/ch1_txusrclk] \
    [get_bd_pins gt_quad_1/ch2_txusrclk] \
    [get_bd_pins gt_quad_1/ch3_txusrclk] \
    [get_bd_pins gt_quad_0/ch0_rxusrclk] \
    [get_bd_pins gt_quad_0/ch1_rxusrclk] \
    [get_bd_pins gt_quad_0/ch2_rxusrclk] \
    [get_bd_pins gt_quad_0/ch3_rxusrclk] \
    [get_bd_pins gt_quad_1/ch0_rxusrclk] \
    [get_bd_pins gt_quad_1/ch1_rxusrclk] \
    [get_bd_pins gt_quad_1/ch2_rxusrclk] \
    [get_bd_pins gt_quad_1/ch3_rxusrclk]
  connect_bd_net [get_bd_pins pcie_phy/phy_userclk] [get_bd_pins pcie/phy_userclk]
  connect_bd_net [get_bd_pins pcie_phy/phy_userclk2] [get_bd_pins pcie/phy_userclk2]
  connect_bd_net [get_bd_pins pcie/phy_rdy_out] [get_bd_pins phy_rdy_out]
  connect_bd_net [get_bd_pins pcie/user_clk] [get_bd_pins user_clk]
  connect_bd_net [get_bd_pins pcie/user_lnk_up] [get_bd_pins user_lnk_up]
  connect_bd_net [get_bd_pins pcie/user_reset] [get_bd_pins user_reset]
  connect_bd_net [get_bd_pins refclk_ibuf/IBUF_DS_ODIV2] [get_bd_pins bufg_gt_sysclk/BUFG_GT_I]
  connect_bd_net [get_bd_pins refclk_ibuf/IBUF_OUT] \
    [get_bd_pins pcie_phy/phy_gtrefclk] \
    [get_bd_pins pcie/sys_clk_gt]
  connect_bd_net [get_bd_pins sys_reset] \
    [get_bd_pins pcie_phy/phy_rst_n] \
    [get_bd_pins pcie/sys_reset]

  # Restore current instance
  current_bd_instance $oldCurInst
}
