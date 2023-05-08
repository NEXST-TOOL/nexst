proc create_design { design_name } {

    create_bd_design ${design_name}
    current_bd_design ${design_name}

    #=============================================
    # Clock ports
    #=============================================

    create_bd_port -dir I -type clk -freq_hz 50000000 aclk

    #=============================================
    # Reset ports
    #=============================================

    create_bd_port -dir I -type rst aresetn
    set_property CONFIG.ASSOCIATED_RESET {aresetn} [get_bd_ports aclk]

    #=============================================
    # AXI ports
    #=============================================

    set m_axi_mem [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mem]
    set_property -dict [ list CONFIG.PROTOCOL {AXI4} \
        CONFIG.ADDR_WIDTH {36} \
        CONFIG.DATA_WIDTH {256} ] $m_axi_mem

    set s_axi_ctrl [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ctrl]
    set_property -dict [ list CONFIG.PROTOCOL {AXI4Lite} \
        CONFIG.ADDR_WIDTH {20} \
        CONFIG.DATA_WIDTH {32} ] $s_axi_ctrl

    set_property CONFIG.ASSOCIATED_BUSIF {m_axi_mem:s_axi_ctrl} [get_bd_ports aclk]

    #=============================================
    # Create IP blocks
    #=============================================

    # Create instance: emu_system
    set emu_system [create_bd_cell -type module -reference EMU_SYSTEM emu_system]
    set emu_system_axi_list [get_bd_intf_pins emu_system/EMU_AXI_*]
    lappend emu_system_axi_list [get_bd_intf_pins emu_system/EMU_SCAN_DMA_AXI]
    set m_axi_num [llength $emu_system_axi_list]

    set axi_names {EMU_CTRL}
    foreach axi $emu_system_axi_list {
        append axi_names ":" [get_property NAME $axi]
    }
    set_property -dict [list \
        CONFIG.ASSOCIATED_BUSIF $axi_names \
    ] [get_bd_pins emu_system/EMU_HOST_CLK]

    # Create instance: axi_mmio_ic
    set axi_mmio_ic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mmio_ic ]
    set_property -dict [list CONFIG.NUM_MI {1} CONFIG.NUM_SI {1}] $axi_mmio_ic

    # Create instance: axi_mem_ic
    # IMPORTANT: CONFIG.STRATEGY must be set to instantiate crossbar in SASD mode for an AXI master interface without ID signal
    set axi_mem_ic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_ic ]
    set_property -dict [list CONFIG.NUM_MI {1} CONFIG.NUM_SI $m_axi_num CONFIG.STRATEGY {1} ] $axi_mem_ic

    #=============================================
    # System clock connection
    #=============================================

    connect_bd_net [get_bd_ports aclk] \
        [get_bd_pins emu_system/EMU_HOST_CLK] \
        [get_bd_pins axi_mmio_ic/ACLK] \
        [get_bd_pins axi_mmio_ic/S00_ACLK] \
        [get_bd_pins axi_mmio_ic/M00_ACLK] \
        [get_bd_pins axi_mem_ic/ACLK] \
        [get_bd_pins axi_mem_ic/S*_ACLK] \
        [get_bd_pins axi_mem_ic/M00_ACLK]

    #=============================================
    # System reset connection
    #=============================================

    connect_bd_net [get_bd_ports aresetn] \
        [get_bd_pins emu_system/EMU_HOST_RST] \
        [get_bd_pins axi_mmio_ic/ARESETN] \
        [get_bd_pins axi_mmio_ic/S00_ARESETN] \
        [get_bd_pins axi_mmio_ic/M00_ARESETN] \
        [get_bd_pins axi_mem_ic/ARESETN] \
        [get_bd_pins axi_mem_ic/S*_ARESETN] \
        [get_bd_pins axi_mem_ic/M00_ARESETN]

    #=============================================
    # AXI interface connection
    #=============================================

    connect_bd_intf_net [get_bd_intf_ports s_axi_ctrl] [get_bd_intf_pins axi_mmio_ic/S00_AXI]
    connect_bd_intf_net [get_bd_intf_pins axi_mmio_ic/M00_AXI] [get_bd_intf_pins emu_system/EMU_CTRL]

    set i 0
    foreach axi $emu_system_axi_list {
        set fmt_i [format "%02d" $i]
        connect_bd_intf_net $axi [get_bd_intf_pins axi_mem_ic/S${fmt_i}_AXI]
        incr i
    }

    connect_bd_intf_net [get_bd_intf_pins axi_mem_ic/M00_AXI] [get_bd_intf_ports m_axi_mem]

    #=============================================
    # Create address segments
    #=============================================

    foreach axi $emu_system_axi_list {
        create_bd_addr_seg -range 0x1000000000 -offset 0x0 [get_bd_addr_spaces $axi] [get_bd_addr_segs m_axi_mem/Reg] EMU_HOST_AXI
    }

    create_bd_addr_seg -range 0x100000 -offset 0x0 [get_bd_addr_spaces s_axi_ctrl] [get_bd_addr_segs emu_system/EMU_CTRL/reg0] EMU_MMIO

    #=============================================
    # Finish BD creation 
    #=============================================

    save_bd_design

}

# add source HDL files
add_files -fileset sources_1 ${design_dir}/../hardware/sources/generated/
add_files -fileset sources_1 ${design_dir}/../fpga/sources/hdl/
add_files -fileset sources_1 ${design_dir}/../fpga/sources/wrapper/role_top_remu.v

# clear IP catalog
# update_ip_catalog -clear_ip_cache
check_ip_cache -clear_output_repo

set bd_design role
create_design ${bd_design}

set_property synth_checkpoint_mode None [get_files ${bd_design}.bd]
generate_target all [get_files ${bd_design}.bd]

# using a custom wrapper
# make_wrapper -top -import [get_files ${bd_design}.bd]

validate_bd_design
save_bd_design
close_bd_design ${bd_design}

set_property top role_top [get_filesets sources_1]
