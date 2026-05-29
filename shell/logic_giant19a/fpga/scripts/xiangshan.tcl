
################################################################
# This is a generated script based on design: xiangshan
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
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2024.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source xiangshan_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# role_top, f2s_rising_intr_sync, f2s_rising_intr_sync

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvu19p-fsva3824-2-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name xiangshan

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

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:inline_hdl:ilvector_logic:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:ddr4:2.2\
xilinx.com:ip:xdma:4.1\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:inline_hdl:ilconstant:1.0\
xilinx.com:inline_hdl:ilslice:1.0\
xilinx.com:inline_hdl:ilconcat:1.0\
xilinx.com:ip:system_ila:1.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
role_top\
f2s_rising_intr_sync\
f2s_rising_intr_sync\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
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


  # Create interface ports
  set pcie_ep_gt_ref_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_ep_gt_ref_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $pcie_ep_gt_ref_clk

  set ddr4_mig_sys_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr4_mig_sys_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {80000000} \
   ] $ddr4_mig_sys_clk

  set c0_ddr4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 c0_ddr4 ]

  set pcie_rp_j6_gt_ref_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_rp_j6_gt_ref_clk ]

  set pcie_rp_j9_gt_ref_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_rp_j9_gt_ref_clk ]


  # Create ports
  set pcie_ep_perstn [ create_bd_port -dir I -type rst pcie_ep_perstn ]
  set pcie_rp_j9_perstn [ create_bd_port -dir O -type rst pcie_rp_j9_perstn ]
  set pcie_rp_j6_perstn [ create_bd_port -dir O -type rst pcie_rp_j6_perstn ]
  set pcie_ep_rxn [ create_bd_port -dir I -from 7 -to 0 pcie_ep_rxn ]
  set pcie_ep_rxp [ create_bd_port -dir I -from 7 -to 0 pcie_ep_rxp ]
  set pcie_ep_txn [ create_bd_port -dir O -from 7 -to 0 pcie_ep_txn ]
  set pcie_ep_txp [ create_bd_port -dir O -from 7 -to 0 pcie_ep_txp ]
  set pcie_rp_j9_rxn [ create_bd_port -dir I -from 3 -to 0 pcie_rp_j9_rxn ]
  set pcie_rp_j9_rxp [ create_bd_port -dir I -from 3 -to 0 pcie_rp_j9_rxp ]
  set pcie_rp_j9_txn [ create_bd_port -dir O -from 3 -to 0 pcie_rp_j9_txn ]
  set pcie_rp_j9_txp [ create_bd_port -dir O -from 3 -to 0 pcie_rp_j9_txp ]
  set pcie_rp_j6_rxn [ create_bd_port -dir I -from 3 -to 0 pcie_rp_j6_rxn ]
  set pcie_rp_j6_rxp [ create_bd_port -dir I -from 3 -to 0 pcie_rp_j6_rxp ]
  set pcie_rp_j6_txn [ create_bd_port -dir O -from 3 -to 0 pcie_rp_j6_txn ]
  set pcie_rp_j6_txp [ create_bd_port -dir O -from 3 -to 0 pcie_rp_j6_txp ]

  # Create instance: ep_perst_gen, and set properties
  set ep_perst_gen [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilvector_logic:1.0 ep_perst_gen ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $ep_perst_gen


  # Create instance: ddr4_mig_rst_gen, and set properties
  set ddr4_mig_rst_gen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 ddr4_mig_rst_gen ]

  # Create instance: dut_rst_gen, and set properties
  set dut_rst_gen [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 dut_rst_gen ]

  # Create instance: u_role, and set properties
  set block_name role_top
  set block_cell_name u_role
  if { [catch {set u_role [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $u_role eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ddr4_mig, and set properties
  set ddr4_mig [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_mig ]
  set_property -dict [list \
    CONFIG.C0.BANK_GROUP_WIDTH {2} \
    CONFIG.C0.CS_WIDTH {1} \
    CONFIG.C0.DDR4_AxiAddressWidth {33} \
    CONFIG.C0.DDR4_AxiDataWidth {512} \
    CONFIG.C0.DDR4_CasLatency {11} \
    CONFIG.C0.DDR4_DataMask {DM_NO_DBI} \
    CONFIG.C0.DDR4_DataWidth {64} \
    CONFIG.C0.DDR4_InputClockPeriod {12500} \
    CONFIG.C0.DDR4_MemoryPart {MT40A1G16WBU-083E} \
    CONFIG.C0.DDR4_MemoryType {Components} \
    CONFIG.C0.DDR4_TimePeriod {1250} \
    CONFIG.C0.DDR4_isCustom {false} \
    CONFIG.System_Clock {Differential} \
  ] $ddr4_mig


  # Create instance: xdma_ep, and set properties
  set xdma_ep [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_ep ]
  set_property -dict [list \
    CONFIG.axilite_master_en {true} \
    CONFIG.axilite_master_scale {Megabytes} \
    CONFIG.axilite_master_size {32} \
    CONFIG.axist_bypass_en {true} \
    CONFIG.axist_bypass_scale {Megabytes} \
    CONFIG.axist_bypass_size {256} \
    CONFIG.cfg_mgmt_if {false} \
    CONFIG.en_gt_selection {true} \
    CONFIG.functional_mode {DMA} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.pcie_blk_locn {PCIE4C_X0Y4} \
    CONFIG.pciebar2axibar_axil_master {0x10000000} \
    CONFIG.pf0_base_class_menu {Processing_accelerators} \
    CONFIG.pf0_sub_class_interface_menu {Unknown} \
    CONFIG.pl_link_cap_max_link_speed {2.5_GT/s} \
    CONFIG.pl_link_cap_max_link_width {X8} \
    CONFIG.select_quad {GTY_Quad_232} \
    CONFIG.xdma_axi_intf_mm {AXI_Memory_Mapped} \
  ] $xdma_ep


  # Create instance: xdma_rp_j9, and set properties
  set xdma_rp_j9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_rp_j9 ]
  set_property -dict [list \
    CONFIG.BASEADDR {0x00000000} \
    CONFIG.HIGHADDR {0x007FFFFF} \
    CONFIG.axi_addr_width {64} \
    CONFIG.axi_data_width {128_bit} \
    CONFIG.axibar2pciebar_0 {0x0000000050000000} \
    CONFIG.axisten_freq {250} \
    CONFIG.device_port_type {Root_Port_of_PCI_Express_Root_Complex} \
    CONFIG.dma_reset_source_sel {Phy_Ready} \
    CONFIG.en_gt_selection {true} \
    CONFIG.functional_mode {AXI_Bridge} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.msi_rx_pin_en {TRUE} \
    CONFIG.pcie_blk_locn {PCIE4C_X0Y4} \
    CONFIG.pf0_bar0_enabled {false} \
    CONFIG.pf0_class_code_sub {04} \
    CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
    CONFIG.pl_link_cap_max_link_width {X4} \
    CONFIG.plltype {QPLL1} \
    CONFIG.select_quad {GTY_Quad_232} \
  ] $xdma_rp_j9


  # Create instance: xdma_rp_j6, and set properties
  set xdma_rp_j6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_rp_j6 ]
  set_property -dict [list \
    CONFIG.BASEADDR {0x00000000} \
    CONFIG.HIGHADDR {0x007FFFFF} \
    CONFIG.axi_addr_width {64} \
    CONFIG.axi_data_width {256_bit} \
    CONFIG.axibar2pciebar_0 {0x0000000051000000} \
    CONFIG.axisten_freq {125} \
    CONFIG.device_port_type {Root_Port_of_PCI_Express_Root_Complex} \
    CONFIG.dma_reset_source_sel {Phy_Ready} \
    CONFIG.en_gt_selection {true} \
    CONFIG.functional_mode {AXI_Bridge} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.msi_rx_pin_en {TRUE} \
    CONFIG.pcie_blk_locn {PCIE4C_X0Y1} \
    CONFIG.pf0_bar0_enabled {false} \
    CONFIG.pf0_class_code_sub {04} \
    CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
    CONFIG.pl_link_cap_max_link_width {X4} \
    CONFIG.plltype {QPLL1} \
    CONFIG.select_quad {GTY_Quad_222} \
  ] $xdma_rp_j6


  # Create instance: pcie_ep_ref_clk_buf, and set properties
  set pcie_ep_ref_clk_buf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 pcie_ep_ref_clk_buf ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $pcie_ep_ref_clk_buf


  # Create instance: pcie_slow_clk_gen, and set properties
  set pcie_slow_clk_gen [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 pcie_slow_clk_gen ]
  set_property -dict [list \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {10} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
  ] $pcie_slow_clk_gen


  # Create instance: axi_ic_ddr_mem_xdma_ep, and set properties
  set axi_ic_ddr_mem_xdma_ep [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_ddr_mem_xdma_ep ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {2} \
  ] $axi_ic_ddr_mem_xdma_ep


  # Create instance: axi_ic_ddr_mem_slr1_slr2, and set properties
  set axi_ic_ddr_mem_slr1_slr2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_ddr_mem_slr1_slr2 ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {2} \
  ] $axi_ic_ddr_mem_slr1_slr2


  # Create instance: axi_ic_ep_bar_axi_lite, and set properties
  set axi_ic_ep_bar_axi_lite [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_ep_bar_axi_lite ]
  set_property -dict [list \
    CONFIG.NUM_MI {4} \
    CONFIG.NUM_SI {1} \
  ] $axi_ic_ep_bar_axi_lite


  # Create instance: axi_ic_role_io, and set properties
  set axi_ic_role_io [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_role_io ]
  set_property -dict [list \
    CONFIG.NUM_MI {4} \
    CONFIG.NUM_SI {1} \
  ] $axi_ic_role_io


  # Create instance: axi_ic_pcie_rp_dma, and set properties
  set axi_ic_pcie_rp_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_pcie_rp_dma ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {2} \
  ] $axi_ic_pcie_rp_dma


  # Create instance: axi_ic_pcie_rp_dma_j9, and set properties
  set axi_ic_pcie_rp_dma_j9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_pcie_rp_dma_j9 ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $axi_ic_pcie_rp_dma_j9


  # Create instance: axi_ic_pcie_rp_dma_j6, and set properties
  set axi_ic_pcie_rp_dma_j6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_pcie_rp_dma_j6 ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {1} \
  ] $axi_ic_pcie_rp_dma_j6


  # Create instance: axi_ic_pcie_rp_mmio_j6, and set properties
  set axi_ic_pcie_rp_mmio_j6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_pcie_rp_mmio_j6 ]
  set_property -dict [list \
    CONFIG.NUM_MI {2} \
    CONFIG.NUM_SI {1} \
  ] $axi_ic_pcie_rp_mmio_j6


  # Create instance: axi_ic_pcie_rp_mmio_j9, and set properties
  set axi_ic_pcie_rp_mmio_j9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_pcie_rp_mmio_j9 ]
  set_property -dict [list \
    CONFIG.NUM_MI {2} \
    CONFIG.NUM_SI {1} \
  ] $axi_ic_pcie_rp_mmio_j9


  # Create instance: axi_ic_bootrom, and set properties
  set axi_ic_bootrom [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_bootrom ]
  set_property -dict [list \
    CONFIG.NUM_MI {1} \
    CONFIG.NUM_SI {2} \
  ] $axi_ic_bootrom


  # Create instance: host_uart, and set properties
  set host_uart [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 host_uart ]
  set_property CONFIG.C_BAUDRATE {115200} $host_uart


  # Create instance: role_uart, and set properties
  set role_uart [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 role_uart ]
  set_property CONFIG.C_BAUDRATE {115200} $role_uart


  # Create instance: bootrom_bram, and set properties
  set bootrom_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 bootrom_bram ]

  # Create instance: bootrom_bram_ctrl, and set properties
  set bootrom_bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bootrom_bram_ctrl ]
  set_property -dict [list \
    CONFIG.PROTOCOL {AXI4LITE} \
    CONFIG.SINGLE_PORT_BRAM {1} \
  ] $bootrom_bram_ctrl


  # Create instance: axi_mm_base_reg, and set properties
  set axi_mm_base_reg [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_mm_base_reg ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_DOUT_DEFAULT {0x00000000} \
    CONFIG.C_GPIO_WIDTH {8} \
  ] $axi_mm_base_reg


  # Create instance: const_vcc, and set properties
  set const_vcc [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 const_vcc ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x1} \
    CONFIG.CONST_WIDTH {1} \
  ] $const_vcc


  # Create instance: const_gnd, and set properties
  set const_gnd [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 const_gnd ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x0} \
    CONFIG.CONST_WIDTH {1} \
  ] $const_gnd


  # Create instance: const_28b0, and set properties
  set const_28b0 [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 const_28b0 ]
  set_property -dict [list \
    CONFIG.CONST_VAL {0x0} \
    CONFIG.CONST_WIDTH {28} \
  ] $const_28b0


  # Create instance: slice_xdma_ep_m_axib_araddr, and set properties
  set slice_xdma_ep_m_axib_araddr [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 slice_xdma_ep_m_axib_araddr ]
  set_property -dict [list \
    CONFIG.DIN_FROM {27} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {64} \
  ] $slice_xdma_ep_m_axib_araddr


  # Create instance: concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_araddr, and set properties
  set concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_araddr [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat:1.0 concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_araddr ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {28} \
    CONFIG.IN1_WIDTH {8} \
    CONFIG.IN2_WIDTH {28} \
    CONFIG.NUM_PORTS {3} \
  ] $concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_araddr


  # Create instance: slice_xdma_ep_m_axib_awaddr, and set properties
  set slice_xdma_ep_m_axib_awaddr [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 slice_xdma_ep_m_axib_awaddr ]
  set_property -dict [list \
    CONFIG.DIN_FROM {27} \
    CONFIG.DIN_TO {0} \
    CONFIG.DIN_WIDTH {64} \
  ] $slice_xdma_ep_m_axib_awaddr


  # Create instance: concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_awaddr, and set properties
  set concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_awaddr [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat:1.0 concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_awaddr ]
  set_property -dict [list \
    CONFIG.IN0_WIDTH {28} \
    CONFIG.IN1_WIDTH {8} \
    CONFIG.IN2_WIDTH {28} \
    CONFIG.NUM_PORTS {3} \
  ] $concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_awaddr


  # Create instance: intr_sync_xdma_rp_j9, and set properties
  set block_name f2s_rising_intr_sync
  set block_cell_name intr_sync_xdma_rp_j9
  if { [catch {set intr_sync_xdma_rp_j9 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $intr_sync_xdma_rp_j9 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.INTR_WIDTH {3} \
    CONFIG.SYNC_STAGE {2} \
  ] $intr_sync_xdma_rp_j9


  # Create instance: intr_sync_xdma_rp_j6, and set properties
  set block_name f2s_rising_intr_sync
  set block_cell_name intr_sync_xdma_rp_j6
  if { [catch {set intr_sync_xdma_rp_j6 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $intr_sync_xdma_rp_j6 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.INTR_WIDTH {3} \
    CONFIG.SYNC_STAGE {2} \
  ] $intr_sync_xdma_rp_j6


  # Create instance: xdma_rp_j9_intr_concat, and set properties
  set xdma_rp_j9_intr_concat [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat:1.0 xdma_rp_j9_intr_concat ]
  set_property CONFIG.NUM_PORTS {3} $xdma_rp_j9_intr_concat


  # Create instance: xdma_rp_j6_intr_concat, and set properties
  set xdma_rp_j6_intr_concat [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat:1.0 xdma_rp_j6_intr_concat ]
  set_property CONFIG.NUM_PORTS {3} $xdma_rp_j6_intr_concat


  # Create instance: role_intr_concat, and set properties
  set role_intr_concat [ create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat:1.0 role_intr_concat ]
  set_property -dict [list \
    CONFIG.IN1_WIDTH {3} \
    CONFIG.IN2_WIDTH {3} \
    CONFIG.NUM_PORTS {3} \
  ] $role_intr_concat


  # Create instance: system_ila, and set properties
  set system_ila [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila ]
  set_property CONFIG.C_NUM_MONITOR_SLOTS {2} $system_ila


  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_0 ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $util_ds_buf_0


  # Create instance: util_ds_buf_1, and set properties
  set util_ds_buf_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_1 ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $util_ds_buf_1


  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN_D_0_1 [get_bd_intf_ports pcie_rp_j6_gt_ref_clk] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
  connect_bd_intf_net -intf_net CLK_IN_D_1_1 [get_bd_intf_ports pcie_rp_j9_gt_ref_clk] [get_bd_intf_pins util_ds_buf_1/CLK_IN_D]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_ic_bootrom/S00_AXI] [get_bd_intf_pins axi_ic_role_io/M01_AXI]
  connect_bd_intf_net -intf_net S00_AXI_2 [get_bd_intf_pins axi_ic_pcie_rp_mmio_j9/S00_AXI] [get_bd_intf_pins axi_ic_role_io/M02_AXI]
  connect_bd_intf_net -intf_net S00_AXI_3 [get_bd_intf_pins axi_ic_pcie_rp_mmio_j6/S00_AXI] [get_bd_intf_pins axi_ic_role_io/M03_AXI]
  connect_bd_intf_net -intf_net S01_AXI_1 [get_bd_intf_pins axi_ic_bootrom/S01_AXI] [get_bd_intf_pins axi_ic_ep_bar_axi_lite/M02_AXI]
  connect_bd_intf_net -intf_net axi_ic_bootrom_M00_AXI [get_bd_intf_pins bootrom_bram_ctrl/S_AXI] [get_bd_intf_pins axi_ic_bootrom/M00_AXI]
  connect_bd_intf_net -intf_net axi_ic_ddr_mem_slr1_slr2_M00_AXI [get_bd_intf_pins ddr4_mig/C0_DDR4_S_AXI] [get_bd_intf_pins axi_ic_ddr_mem_slr1_slr2/M00_AXI]
  connect_bd_intf_net -intf_net axi_ic_ddr_mem_xdma_ep_M00_AXI [get_bd_intf_pins axi_ic_ddr_mem_xdma_ep/M00_AXI] [get_bd_intf_pins axi_ic_ddr_mem_slr1_slr2/S00_AXI]
  connect_bd_intf_net -intf_net axi_ic_ep_bar_axi_lite_M00_AXI [get_bd_intf_pins host_uart/S_AXI] [get_bd_intf_pins axi_ic_ep_bar_axi_lite/M00_AXI]
  connect_bd_intf_net -intf_net axi_ic_ep_bar_axi_lite_M01_AXI [get_bd_intf_pins u_role/s_axi_ctrl] [get_bd_intf_pins axi_ic_ep_bar_axi_lite/M01_AXI]
  connect_bd_intf_net -intf_net axi_ic_ep_bar_axi_lite_M03_AXI [get_bd_intf_pins axi_mm_base_reg/S_AXI] [get_bd_intf_pins axi_ic_ep_bar_axi_lite/M03_AXI]
  connect_bd_intf_net -intf_net axi_ic_pcie_rp_dma_M00_AXI [get_bd_intf_pins axi_ic_pcie_rp_dma/M00_AXI] [get_bd_intf_pins u_role/s_axi_dma]
  connect_bd_intf_net -intf_net axi_ic_pcie_rp_dma_j6_M00_AXI [get_bd_intf_pins axi_ic_pcie_rp_dma_j6/M00_AXI] [get_bd_intf_pins axi_ic_pcie_rp_dma/S01_AXI]
  connect_bd_intf_net -intf_net axi_ic_pcie_rp_dma_j9_M00_AXI [get_bd_intf_pins axi_ic_pcie_rp_dma_j9/M00_AXI] [get_bd_intf_pins axi_ic_pcie_rp_dma/S00_AXI]
  connect_bd_intf_net -intf_net axi_ic_pcie_rp_mmio_j6_M00_AXI [get_bd_intf_pins axi_ic_pcie_rp_mmio_j6/M00_AXI] [get_bd_intf_pins xdma_rp_j6/S_AXI_B]
  connect_bd_intf_net -intf_net axi_ic_pcie_rp_mmio_j6_M01_AXI [get_bd_intf_pins axi_ic_pcie_rp_mmio_j6/M01_AXI] [get_bd_intf_pins xdma_rp_j6/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_ic_pcie_rp_mmio_j9_M00_AXI [get_bd_intf_pins axi_ic_pcie_rp_mmio_j9/M00_AXI] [get_bd_intf_pins xdma_rp_j9/S_AXI_B]
  connect_bd_intf_net -intf_net axi_ic_pcie_rp_mmio_j9_M01_AXI [get_bd_intf_pins axi_ic_pcie_rp_mmio_j9/M01_AXI] [get_bd_intf_pins xdma_rp_j9/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_ic_role_io_M00_AXI [get_bd_intf_pins role_uart/S_AXI] [get_bd_intf_pins axi_ic_role_io/M00_AXI]
  connect_bd_intf_net -intf_net bootrom_bram_ctrl_BRAM_PORTA [get_bd_intf_pins bootrom_bram_ctrl/BRAM_PORTA] [get_bd_intf_pins bootrom_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net ddr4_mig_C0_DDR4 [get_bd_intf_pins ddr4_mig/C0_DDR4] [get_bd_intf_ports c0_ddr4]
  connect_bd_intf_net -intf_net ddr4_mig_sys_clk_in [get_bd_intf_ports ddr4_mig_sys_clk] [get_bd_intf_pins ddr4_mig/C0_SYS_CLK]
  connect_bd_intf_net -intf_net pcie_ep_gt_ref_clk [get_bd_intf_ports pcie_ep_gt_ref_clk] [get_bd_intf_pins pcie_ep_ref_clk_buf/CLK_IN_D]
  connect_bd_intf_net -intf_net u_role_m_axi_io [get_bd_intf_pins u_role/m_axi_io] [get_bd_intf_pins axi_ic_role_io/S00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets u_role_m_axi_io] [get_bd_intf_pins u_role/m_axi_io] [get_bd_intf_pins system_ila/SLOT_1_AXI]
  connect_bd_intf_net -intf_net u_role_m_axi_mem [get_bd_intf_pins u_role/m_axi_mem] [get_bd_intf_pins axi_ic_ddr_mem_slr1_slr2/S01_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets u_role_m_axi_mem] [get_bd_intf_pins u_role/m_axi_mem] [get_bd_intf_pins system_ila/SLOT_0_AXI]
  connect_bd_intf_net -intf_net xdma_ep_M_AXI [get_bd_intf_pins xdma_ep/M_AXI] [get_bd_intf_pins axi_ic_ddr_mem_xdma_ep/S01_AXI]
  connect_bd_intf_net -intf_net xdma_ep_M_AXI_BYPASS [get_bd_intf_pins xdma_ep/M_AXI_BYPASS] [get_bd_intf_pins axi_ic_ddr_mem_xdma_ep/S00_AXI]
  connect_bd_intf_net -intf_net xdma_ep_M_AXI_LITE [get_bd_intf_pins xdma_ep/M_AXI_LITE] [get_bd_intf_pins axi_ic_ep_bar_axi_lite/S00_AXI]
  connect_bd_intf_net -intf_net xdma_rp_j6_M_AXI_B [get_bd_intf_pins xdma_rp_j6/M_AXI_B] [get_bd_intf_pins axi_ic_pcie_rp_dma_j6/S00_AXI]
  connect_bd_intf_net -intf_net xdma_rp_j9_M_AXI_B [get_bd_intf_pins xdma_rp_j9/M_AXI_B] [get_bd_intf_pins axi_ic_pcie_rp_dma_j9/S00_AXI]

  # Create port connections
  connect_bd_net -net axi_mm_base_reg_gpio_io_o  [get_bd_pins axi_mm_base_reg/gpio_io_o] \
  [get_bd_pins concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_araddr/In1] \
  [get_bd_pins concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_awaddr/In1]
  connect_bd_net -net concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_araddr_dout  [get_bd_pins concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_araddr/dout] \
  [get_bd_pins axi_ic_ddr_mem_xdma_ep/S00_AXI_araddr]
  connect_bd_net -net concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_awaddr_dout  [get_bd_pins concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_awaddr/dout] \
  [get_bd_pins axi_ic_ddr_mem_xdma_ep/S00_AXI_awaddr]
  connect_bd_net -net const_28b0_dout  [get_bd_pins const_28b0/dout] \
  [get_bd_pins concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_araddr/In2] \
  [get_bd_pins concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_awaddr/In2]
  connect_bd_net -net ddr4_mig_c0_ddr4_ui_clk  [get_bd_pins ddr4_mig/c0_ddr4_ui_clk] \
  [get_bd_pins axi_ic_ddr_mem_slr1_slr2/ACLK] \
  [get_bd_pins axi_ic_ddr_mem_slr1_slr2/M00_ACLK] \
  [get_bd_pins ddr4_mig_rst_gen/slowest_sync_clk]
  connect_bd_net -net ddr4_mig_rst_gen_interconnect_aresetn  [get_bd_pins ddr4_mig_rst_gen/interconnect_aresetn] \
  [get_bd_pins axi_ic_ddr_mem_slr1_slr2/ARESETN] \
  [get_bd_pins axi_ic_ddr_mem_slr1_slr2/M00_ARESETN]
  connect_bd_net -net ddr4_mig_rst_gen_peripheral_aresetn  [get_bd_pins ddr4_mig_rst_gen/peripheral_aresetn] \
  [get_bd_pins ddr4_mig/c0_ddr4_aresetn]
  connect_bd_net -net dut_rst_gen_interconnect_aresetn  [get_bd_pins dut_rst_gen/interconnect_aresetn] \
  [get_bd_pins axi_ic_role_io/ARESETN] \
  [get_bd_pins axi_ic_role_io/S00_ARESETN] \
  [get_bd_pins axi_ic_role_io/M00_ARESETN] \
  [get_bd_pins axi_ic_role_io/M01_ARESETN] \
  [get_bd_pins axi_ic_role_io/M02_ARESETN] \
  [get_bd_pins axi_ic_role_io/M03_ARESETN] \
  [get_bd_pins axi_ic_bootrom/ARESETN] \
  [get_bd_pins axi_ic_bootrom/S00_ARESETN] \
  [get_bd_pins axi_ic_bootrom/S01_ARESETN] \
  [get_bd_pins axi_ic_bootrom/M00_ARESETN] \
  [get_bd_pins axi_ic_pcie_rp_mmio_j9/S00_ARESETN] \
  [get_bd_pins axi_ic_pcie_rp_mmio_j6/S00_ARESETN] \
  [get_bd_pins axi_ic_ddr_mem_slr1_slr2/S00_ARESETN] \
  [get_bd_pins axi_ic_ddr_mem_slr1_slr2/S01_ARESETN] \
  [get_bd_pins axi_ic_pcie_rp_dma/ARESETN] \
  [get_bd_pins axi_ic_pcie_rp_dma/S00_ARESETN] \
  [get_bd_pins axi_ic_pcie_rp_dma/S01_ARESETN] \
  [get_bd_pins axi_ic_pcie_rp_dma/M00_ARESETN] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/M00_ARESETN] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/M01_ARESETN] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/M02_ARESETN] \
  [get_bd_pins axi_ic_ddr_mem_xdma_ep/M00_ARESETN] \
  [get_bd_pins axi_ic_pcie_rp_dma_j9/M00_ARESETN] \
  [get_bd_pins axi_ic_pcie_rp_dma_j6/M00_ARESETN]
  connect_bd_net -net dut_rst_gen_peripheral_aresetn  [get_bd_pins dut_rst_gen/peripheral_aresetn] \
  [get_bd_pins u_role/aresetn] \
  [get_bd_pins role_uart/s_axi_aresetn] \
  [get_bd_pins bootrom_bram_ctrl/s_axi_aresetn] \
  [get_bd_pins host_uart/s_axi_aresetn] \
  [get_bd_pins system_ila/resetn]
  connect_bd_net -net ep_perst_gen_Res  [get_bd_pins ep_perst_gen/Res] \
  [get_bd_pins ddr4_mig/sys_rst]
  connect_bd_net -net host_uart_tx  [get_bd_pins host_uart/tx] \
  [get_bd_pins role_uart/rx]
  connect_bd_net -net intr_sync_xdma_rp_j6_slow_intr  [get_bd_pins intr_sync_xdma_rp_j6/slow_intr] \
  [get_bd_pins role_intr_concat/In2]
  connect_bd_net -net intr_sync_xdma_rp_j9_slow_intr  [get_bd_pins intr_sync_xdma_rp_j9/slow_intr] \
  [get_bd_pins role_intr_concat/In1]
  connect_bd_net -net mig_calib_done  [get_bd_pins ddr4_mig/c0_init_calib_complete] \
  [get_bd_pins ddr4_mig_rst_gen/dcm_locked]
  connect_bd_net -net pcie_ep_perstn_1  [get_bd_ports pcie_ep_perstn] \
  [get_bd_pins xdma_ep/sys_rst_n] \
  [get_bd_pins xdma_rp_j9/sys_rst_n] \
  [get_bd_pins xdma_rp_j6/sys_rst_n] \
  [get_bd_pins pcie_slow_clk_gen/resetn] \
  [get_bd_pins ddr4_mig_rst_gen/ext_reset_in] \
  [get_bd_pins dut_rst_gen/ext_reset_in] \
  [get_bd_pins ep_perst_gen/Op1]
  connect_bd_net -net pcie_ep_rxn_1  [get_bd_ports pcie_ep_rxn] \
  [get_bd_pins xdma_ep/pci_exp_rxn]
  connect_bd_net -net pcie_ep_rxp_1  [get_bd_ports pcie_ep_rxp] \
  [get_bd_pins xdma_ep/pci_exp_rxp]
  connect_bd_net -net pcie_ep_sys_clk  [get_bd_pins pcie_ep_ref_clk_buf/IBUF_DS_ODIV2] \
  [get_bd_pins xdma_ep/sys_clk]
  connect_bd_net -net pcie_ep_sys_clk_gt  [get_bd_pins pcie_ep_ref_clk_buf/IBUF_OUT] \
  [get_bd_pins xdma_ep/sys_clk_gt]
  connect_bd_net -net pcie_fast_clk  [get_bd_pins xdma_ep/axi_aclk] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/ACLK] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/S00_ACLK] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/M03_ACLK] \
  [get_bd_pins axi_ic_ddr_mem_xdma_ep/ACLK] \
  [get_bd_pins axi_ic_ddr_mem_xdma_ep/S00_ACLK] \
  [get_bd_pins axi_ic_ddr_mem_xdma_ep/S01_ACLK] \
  [get_bd_pins axi_mm_base_reg/s_axi_aclk] \
  [get_bd_pins pcie_slow_clk_gen/clk_in1]
  connect_bd_net -net pcie_rp_j6_rxn_1  [get_bd_ports pcie_rp_j6_rxn] \
  [get_bd_pins xdma_rp_j6/pci_exp_rxn]
  connect_bd_net -net pcie_rp_j6_rxp_1  [get_bd_ports pcie_rp_j6_rxp] \
  [get_bd_pins xdma_rp_j6/pci_exp_rxp]
  connect_bd_net -net pcie_rp_j9_rxn_1  [get_bd_ports pcie_rp_j9_rxn] \
  [get_bd_pins xdma_rp_j9/pci_exp_rxn]
  connect_bd_net -net pcie_rp_j9_rxp_1  [get_bd_ports pcie_rp_j9_rxp] \
  [get_bd_pins xdma_rp_j9/pci_exp_rxp]
  connect_bd_net -net pcie_slow_clk1  [get_bd_pins pcie_slow_clk_gen/clk_out1] \
  [get_bd_pins dut_rst_gen/slowest_sync_clk] \
  [get_bd_pins u_role/aclk] \
  [get_bd_pins host_uart/s_axi_aclk] \
  [get_bd_pins role_uart/s_axi_aclk] \
  [get_bd_pins bootrom_bram_ctrl/s_axi_aclk] \
  [get_bd_pins intr_sync_xdma_rp_j9/slow_clk] \
  [get_bd_pins intr_sync_xdma_rp_j6/slow_clk] \
  [get_bd_pins axi_ic_bootrom/ACLK] \
  [get_bd_pins axi_ic_bootrom/S00_ACLK] \
  [get_bd_pins axi_ic_bootrom/S01_ACLK] \
  [get_bd_pins axi_ic_bootrom/M00_ACLK] \
  [get_bd_pins axi_ic_ddr_mem_xdma_ep/M00_ACLK] \
  [get_bd_pins axi_ic_ddr_mem_slr1_slr2/S00_ACLK] \
  [get_bd_pins axi_ic_ddr_mem_slr1_slr2/S01_ACLK] \
  [get_bd_pins axi_ic_role_io/ACLK] \
  [get_bd_pins axi_ic_role_io/S00_ACLK] \
  [get_bd_pins axi_ic_role_io/M00_ACLK] \
  [get_bd_pins axi_ic_role_io/M01_ACLK] \
  [get_bd_pins axi_ic_role_io/M02_ACLK] \
  [get_bd_pins axi_ic_role_io/M03_ACLK] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/M00_ACLK] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/M01_ACLK] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/M02_ACLK] \
  [get_bd_pins axi_ic_pcie_rp_dma/ACLK] \
  [get_bd_pins axi_ic_pcie_rp_dma/M00_ACLK] \
  [get_bd_pins axi_ic_pcie_rp_dma/S00_ACLK] \
  [get_bd_pins axi_ic_pcie_rp_dma/S01_ACLK] \
  [get_bd_pins axi_ic_pcie_rp_dma_j9/M00_ACLK] \
  [get_bd_pins axi_ic_pcie_rp_mmio_j9/S00_ACLK] \
  [get_bd_pins axi_ic_pcie_rp_dma_j6/M00_ACLK] \
  [get_bd_pins axi_ic_pcie_rp_mmio_j6/S00_ACLK] \
  [get_bd_pins system_ila/clk]
  connect_bd_net -net pcie_slow_clk2  [get_bd_pins pcie_slow_clk_gen/clk_out2] \
  [get_bd_pins u_role/rtc_clock]
  connect_bd_net -net pcie_slow_clk_gen_locked  [get_bd_pins pcie_slow_clk_gen/locked] \
  [get_bd_pins dut_rst_gen/dcm_locked]
  connect_bd_net -net role_intr_concat_dout  [get_bd_pins role_intr_concat/dout] \
  [get_bd_pins u_role/s2r_intr]
  connect_bd_net -net role_uart_interrupt  [get_bd_pins role_uart/interrupt] \
  [get_bd_pins role_intr_concat/In0]
  connect_bd_net -net role_uart_tx  [get_bd_pins role_uart/tx] \
  [get_bd_pins host_uart/rx]
  connect_bd_net -net slice_xdma_ep_m_axib_araddr_Dout  [get_bd_pins slice_xdma_ep_m_axib_araddr/Dout] \
  [get_bd_pins concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_araddr/In0]
  connect_bd_net -net slice_xdma_ep_m_axib_awaddr_Dout  [get_bd_pins slice_xdma_ep_m_axib_awaddr/Dout] \
  [get_bd_pins concat_axi_ic_ddr_mem_xdma_ep_S00_AXI_awaddr/In0]
  connect_bd_net -net util_ds_buf_0_IBUF_DS_ODIV2  [get_bd_pins util_ds_buf_0/IBUF_DS_ODIV2] \
  [get_bd_pins xdma_rp_j6/sys_clk]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT  [get_bd_pins util_ds_buf_0/IBUF_OUT] \
  [get_bd_pins xdma_rp_j6/sys_clk_gt]
  connect_bd_net -net util_ds_buf_1_IBUF_DS_ODIV2  [get_bd_pins util_ds_buf_1/IBUF_DS_ODIV2] \
  [get_bd_pins xdma_rp_j9/sys_clk]
  connect_bd_net -net util_ds_buf_1_IBUF_OUT  [get_bd_pins util_ds_buf_1/IBUF_OUT] \
  [get_bd_pins xdma_rp_j9/sys_clk_gt]
  connect_bd_net -net xdma_ep_axi_aresetn  [get_bd_pins xdma_ep/axi_aresetn] \
  [get_bd_pins axi_mm_base_reg/s_axi_aresetn] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/ARESETN] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/S00_ARESETN] \
  [get_bd_pins axi_ic_ep_bar_axi_lite/M03_ARESETN] \
  [get_bd_pins axi_ic_ddr_mem_xdma_ep/ARESETN] \
  [get_bd_pins axi_ic_ddr_mem_xdma_ep/S00_ARESETN] \
  [get_bd_pins axi_ic_ddr_mem_xdma_ep/S01_ARESETN]
  connect_bd_net -net xdma_ep_m_axib_araddr  [get_bd_pins xdma_ep/m_axib_araddr] \
  [get_bd_pins slice_xdma_ep_m_axib_araddr/Din]
  connect_bd_net -net xdma_ep_m_axib_awaddr  [get_bd_pins xdma_ep/m_axib_awaddr] \
  [get_bd_pins slice_xdma_ep_m_axib_awaddr/Din]
  connect_bd_net -net xdma_ep_pci_exp_txn  [get_bd_pins xdma_ep/pci_exp_txn] \
  [get_bd_ports pcie_ep_txn]
  connect_bd_net -net xdma_ep_pci_exp_txp  [get_bd_pins xdma_ep/pci_exp_txp] \
  [get_bd_ports pcie_ep_txp]
  connect_bd_net -net xdma_rp_j6_axi_aclk  [get_bd_pins xdma_rp_j6/axi_aclk] \
  [get_bd_pins axi_ic_pcie_rp_dma_j6/ACLK] \
  [get_bd_pins axi_ic_pcie_rp_dma_j6/S00_ACLK] \
  [get_bd_pins axi_ic_pcie_rp_mmio_j6/ACLK] \
  [get_bd_pins axi_ic_pcie_rp_mmio_j6/M00_ACLK] \
  [get_bd_pins axi_ic_pcie_rp_mmio_j6/M01_ACLK] \
  [get_bd_pins intr_sync_xdma_rp_j6/fast_clk]
  connect_bd_net -net xdma_rp_j6_axi_aresetn  [get_bd_pins xdma_rp_j6/axi_aresetn] \
  [get_bd_pins axi_ic_pcie_rp_dma_j6/ARESETN] \
  [get_bd_pins axi_ic_pcie_rp_dma_j6/S00_ARESETN] \
  [get_bd_pins axi_ic_pcie_rp_mmio_j6/ARESETN] \
  [get_bd_pins axi_ic_pcie_rp_mmio_j6/M00_ARESETN] \
  [get_bd_pins axi_ic_pcie_rp_mmio_j6/M01_ARESETN]
  connect_bd_net -net xdma_rp_j6_interrupt_out  [get_bd_pins xdma_rp_j6/interrupt_out] \
  [get_bd_pins xdma_rp_j6_intr_concat/In0]
  connect_bd_net -net xdma_rp_j6_interrupt_out_msi_vec0to31  [get_bd_pins xdma_rp_j6/interrupt_out_msi_vec0to31] \
  [get_bd_pins xdma_rp_j6_intr_concat/In1]
  connect_bd_net -net xdma_rp_j6_interrupt_out_msi_vec32to63  [get_bd_pins xdma_rp_j6/interrupt_out_msi_vec32to63] \
  [get_bd_pins xdma_rp_j6_intr_concat/In2]
  connect_bd_net -net xdma_rp_j6_intr_concat_dout  [get_bd_pins xdma_rp_j6_intr_concat/dout] \
  [get_bd_pins intr_sync_xdma_rp_j6/fast_intr]
  connect_bd_net -net xdma_rp_j6_pci_exp_txn  [get_bd_pins xdma_rp_j6/pci_exp_txn] \
  [get_bd_ports pcie_rp_j6_txn]
  connect_bd_net -net xdma_rp_j6_pci_exp_txp  [get_bd_pins xdma_rp_j6/pci_exp_txp] \
  [get_bd_ports pcie_rp_j6_txp]
  connect_bd_net -net xdma_rp_j9_axi_aclk  [get_bd_pins xdma_rp_j9/axi_aclk] \
  [get_bd_pins axi_ic_pcie_rp_dma_j9/ACLK] \
  [get_bd_pins axi_ic_pcie_rp_dma_j9/S00_ACLK] \
  [get_bd_pins axi_ic_pcie_rp_mmio_j9/ACLK] \
  [get_bd_pins axi_ic_pcie_rp_mmio_j9/M00_ACLK] \
  [get_bd_pins axi_ic_pcie_rp_mmio_j9/M01_ACLK] \
  [get_bd_pins intr_sync_xdma_rp_j9/fast_clk]
  connect_bd_net -net xdma_rp_j9_axi_aresetn  [get_bd_pins xdma_rp_j9/axi_aresetn] \
  [get_bd_pins axi_ic_pcie_rp_dma_j9/ARESETN] \
  [get_bd_pins axi_ic_pcie_rp_dma_j9/S00_ARESETN] \
  [get_bd_pins axi_ic_pcie_rp_mmio_j9/ARESETN] \
  [get_bd_pins axi_ic_pcie_rp_mmio_j9/M00_ARESETN] \
  [get_bd_pins axi_ic_pcie_rp_mmio_j9/M01_ARESETN]
  connect_bd_net -net xdma_rp_j9_interrupt_out  [get_bd_pins xdma_rp_j9/interrupt_out] \
  [get_bd_pins xdma_rp_j9_intr_concat/In0]
  connect_bd_net -net xdma_rp_j9_interrupt_out_msi_vec0to31  [get_bd_pins xdma_rp_j9/interrupt_out_msi_vec0to31] \
  [get_bd_pins xdma_rp_j9_intr_concat/In1]
  connect_bd_net -net xdma_rp_j9_interrupt_out_msi_vec32to63  [get_bd_pins xdma_rp_j9/interrupt_out_msi_vec32to63] \
  [get_bd_pins xdma_rp_j9_intr_concat/In2]
  connect_bd_net -net xdma_rp_j9_intr_concat_dout  [get_bd_pins xdma_rp_j9_intr_concat/dout] \
  [get_bd_pins intr_sync_xdma_rp_j9/fast_intr]
  connect_bd_net -net xdma_rp_j9_pci_exp_txn  [get_bd_pins xdma_rp_j9/pci_exp_txn] \
  [get_bd_ports pcie_rp_j9_txn]
  connect_bd_net -net xdma_rp_j9_pci_exp_txp  [get_bd_pins xdma_rp_j9/pci_exp_txp] \
  [get_bd_ports pcie_rp_j9_txp]

  # Create address segments
  assign_bd_address -offset 0x51000000 -range 0x01000000 -with_name PCIE_RP_J6_S_BAR -target_address_space [get_bd_addr_spaces u_role/m_axi_io] [get_bd_addr_segs xdma_rp_j6/S_AXI_B/BAR0] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -with_name PCIE_RP_J6_S_LITE -target_address_space [get_bd_addr_spaces u_role/m_axi_io] [get_bd_addr_segs xdma_rp_j6/S_AXI_LITE/CTL0] -force
  assign_bd_address -offset 0x50000000 -range 0x01000000 -with_name PCIE_RP_J9_S_BAR -target_address_space [get_bd_addr_spaces u_role/m_axi_io] [get_bd_addr_segs xdma_rp_j9/S_AXI_B/BAR0] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -with_name PCIE_RP_J9_S_LITE -target_address_space [get_bd_addr_spaces u_role/m_axi_io] [get_bd_addr_segs xdma_rp_j9/S_AXI_LITE/CTL0] -force
  assign_bd_address -offset 0x10000000 -range 0x00010000 -with_name ROLE_BOOTROM -target_address_space [get_bd_addr_spaces u_role/m_axi_io] [get_bd_addr_segs bootrom_bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x30000000 -range 0x00010000 -with_name ROLE_UART -target_address_space [get_bd_addr_spaces u_role/m_axi_io] [get_bd_addr_segs role_uart/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x001000000000 -with_name ROLE_DDR -target_address_space [get_bd_addr_spaces u_role/m_axi_mem] [get_bd_addr_segs ddr4_mig/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x00000000 -range 0x001000000000 -with_name PCIE_EP_DMA_DDR -target_address_space [get_bd_addr_spaces xdma_ep/M_AXI] [get_bd_addr_segs ddr4_mig/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x00000000 -range 0x001000000000 -with_name PCIE_EP_BAR_DDR -target_address_space [get_bd_addr_spaces xdma_ep/M_AXI_BYPASS] [get_bd_addr_segs ddr4_mig/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x10010000 -range 0x00001000 -with_name PCIE_EP_BAR_AXI_MM_BASE_REG -target_address_space [get_bd_addr_spaces xdma_ep/M_AXI_LITE] [get_bd_addr_segs axi_mm_base_reg/S_AXI/Reg] -force
  assign_bd_address -offset 0x10000000 -range 0x00010000 -with_name PCIE_EP_BAR_BOOTROM -target_address_space [get_bd_addr_spaces xdma_ep/M_AXI_LITE] [get_bd_addr_segs bootrom_bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x10011000 -range 0x00001000 -with_name PCIE_EP_BAR_HOST_UART -target_address_space [get_bd_addr_spaces xdma_ep/M_AXI_LITE] [get_bd_addr_segs host_uart/S_AXI/Reg] -force
  assign_bd_address -offset 0x10100000 -range 0x00100000 -with_name PCIE_EP_BAR_ROLE_CTRL -target_address_space [get_bd_addr_spaces xdma_ep/M_AXI_LITE] [get_bd_addr_segs u_role/s_axi_ctrl/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x001000000000 -with_name PCIE_RP_J9_DMA -target_address_space [get_bd_addr_spaces xdma_rp_j9/M_AXI_B] [get_bd_addr_segs u_role/s_axi_dma/reg0] -force
  assign_bd_address -offset 0x00000000 -range 0x001000000000 -with_name PCIE_RP_J6_DMA -target_address_space [get_bd_addr_spaces xdma_rp_j6/M_AXI_B] [get_bd_addr_segs u_role/s_axi_dma/reg0] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


