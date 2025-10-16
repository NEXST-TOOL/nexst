#========================================================
# Vivado BD design auto run script for mpsoc
# Based on Vivado 2019.1
# Author: Yisong Chang (changyisong@ict.ac.cn)
# Date: 09/06/2020
#========================================================

namespace eval mpsoc_bd_val {
	set design_name placeholder_role
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

   # Create instance: emu_clk_gen
   set emu_clk_gen [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 emu_clk_gen]
   set_property -dict [list \
      CONFIG.RESET_TYPE {ACTIVE_LOW} \
      CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50} \
   ] $emu_clk_gen

   # Create instance: emu_rst_gen
   set emu_rst_gen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 emu_rst_gen]

   # Create instance: AXI IC for AXI-Lite slave instance of PCIe RC
   set axi_ic_role [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ic_role ]
   set_property -dict [ list CONFIG.NUM_MI {3} \
      CONFIG.NUM_SI {2} ] $axi_ic_role

   # Create dummy GPIO
   set gpio_dummy [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_dummy]
   set_property -dict [list \
      CONFIG.C_GPIO_WIDTH {32} \
      CONFIG.C_DOUT_DEFAULT {0x12345678} \
      CONFIG.C_ALL_OUTPUTS {1} \
   ] $gpio_dummy

  # Create instance: u_axis_whitehole
  set u_axis_whitehole [create_bd_cell -type module -reference axis_whitehole u_axis_whitehole]
  set_property -dict [list CONFIG.DATA_WIDTH {512}] $u_axis_whitehole

#=============================================
# Clock ports
#=============================================

  # Single-end input clock 
  create_bd_port -dir I -type clk -freq_hz 250000000 aclk

#=============================================
# Reset ports
#=============================================

  # PCIe RC perst
  create_bd_port -dir I -type rst aresetn
  set_property CONFIG.ASSOCIATED_RESET {aresetn} [get_bd_ports aclk]

#=============================================
# AXI ports
#=============================================
  
  set s_axi_ctrl [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ctrl]
  set_property -dict [ list CONFIG.PROTOCOL {AXI4Lite} \
				CONFIG.ADDR_WIDTH {20} \
				CONFIG.DATA_WIDTH {32} ] $s_axi_ctrl
  
  set s_axi_dma [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_dma]
  set_property -dict [ list CONFIG.PROTOCOL {AXI4} \
				CONFIG.ADDR_WIDTH {36} \
				CONFIG.DATA_WIDTH {128} ] $s_axi_dma

  set m_axi_io [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_io]
  set_property -dict [ list CONFIG.PROTOCOL {AXI4} \
				CONFIG.ADDR_WIDTH {32} \
				CONFIG.DATA_WIDTH {32} ] $m_axi_io

  set m_axi_mem [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mem]
  set_property -dict [ list CONFIG.PROTOCOL {AXI4} \
				CONFIG.ADDR_WIDTH {36} \
				CONFIG.DATA_WIDTH {256} ] $m_axi_mem

   create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_trace

  set_property CONFIG.ASSOCIATED_BUSIF {s_axi_ctrl:s_axi_ctrl:m_axi_io:m_axi_mem:m_axis_trace} [get_bd_ports aclk]

#=============================================
# System clock connection
#=============================================

  # PCIe RP #0 reference clock
  connect_bd_net [get_bd_pins axi_ic_role/ACLK] \
      [get_bd_pins emu_clk_gen/clk_in1] \
      [get_bd_pins axi_ic_role/S00_ACLK] \
      [get_bd_pins axi_ic_role/S01_ACLK] \
      [get_bd_pins axi_ic_role/M00_ACLK] \
      [get_bd_pins axi_ic_role/M01_ACLK] \
      [get_bd_pins u_axis_whitehole/aclk] \
      [get_bd_ports aclk]

   connect_bd_net [get_bd_pins emu_clk_gen/clk_out1] \
      [get_bd_pins emu_rst_gen/slowest_sync_clk] \
      [get_bd_pins gpio_dummy/s_axi_aclk] \
      [get_bd_pins axi_ic_role/M02_ACLK]

#=============================================
# System reset connection
#=============================================

  # Reset for AXI interface of PCIe RP #0
  connect_bd_net [get_bd_ports aresetn] \
      [get_bd_pins emu_clk_gen/resetn] \
      [get_bd_pins emu_rst_gen/ext_reset_in] \
      [get_bd_pins axi_ic_role/ARESETN] \
      [get_bd_pins axi_ic_role/S00_ARESETN] \
      [get_bd_pins axi_ic_role/S01_ARESETN] \
      [get_bd_pins axi_ic_role/M00_ARESETN] \
      [get_bd_pins axi_ic_role/M01_ARESETN] \
      [get_bd_pins u_axis_whitehole/aresetn]

   connect_bd_net [get_bd_pins emu_clk_gen/locked] \
      [get_bd_pins emu_rst_gen/dcm_locked]

   connect_bd_net [get_bd_pins emu_rst_gen/peripheral_aresetn] \
      [get_bd_pins gpio_dummy/s_axi_aresetn] \
      [get_bd_pins axi_ic_role/M02_ARESETN]


#=============================================
# AXI interface connection
#=============================================

  connect_bd_intf_net [get_bd_intf_ports s_axi_ctrl] \
				[get_bd_intf_pins axi_ic_role/S00_AXI]

  connect_bd_intf_net [get_bd_intf_ports s_axi_dma] \
				[get_bd_intf_pins axi_ic_role/S01_AXI]

  connect_bd_intf_net [get_bd_intf_pins axi_ic_role/M00_AXI] \
				[get_bd_intf_ports m_axi_io]

  connect_bd_intf_net [get_bd_intf_pins axi_ic_role/M01_AXI] \
				[get_bd_intf_ports m_axi_mem]

   connect_bd_intf_net [get_bd_intf_pins axi_ic_role/M02_AXI] \
      [get_bd_intf_pins gpio_dummy/S_AXI]

  connect_bd_intf_net [get_bd_intf_pins u_axis_whitehole/m_axis] \
      [get_bd_intf_ports m_axis_trace]

#=============================================
# Create address segments
#=============================================

assign_bd_address -offset 0x80000 -range 0x10000 -target_address_space [get_bd_addr_spaces s_axi_ctrl] [get_bd_addr_segs gpio_dummy/S_AXI/Reg] -force
assign_bd_address -offset 0x00000 -range 0x80000 -target_address_space [get_bd_addr_spaces s_axi_ctrl] [get_bd_addr_segs m_axi_mem/Reg] -force

#=============================================
# Finish BD creation 
#=============================================

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""

