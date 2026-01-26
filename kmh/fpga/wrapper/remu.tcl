proc create_design { design_name } {

    create_bd_design ${design_name}
    current_bd_design ${design_name}

    #=============================================
    # Clock ports
    #=============================================

    create_bd_port -dir I -type clk -freq_hz 50000000 aclk
    create_bd_port -dir I -type clk -freq_hz 10000000 rtc_clock

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

    set m_axi_io [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_io]
    set_property -dict [ list CONFIG.PROTOCOL {AXI4} \
        CONFIG.ADDR_WIDTH {32} \
        CONFIG.DATA_WIDTH {32} ] $m_axi_io

    set s_axi_dma [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_dma]
    set_property -dict [ list CONFIG.PROTOCOL {AXI4} \
        CONFIG.ADDR_WIDTH {36} \
        CONFIG.ID_WIDTH {4} \
        CONFIG.DATA_WIDTH {256} ] $s_axi_dma

    set_property CONFIG.ASSOCIATED_BUSIF {m_axi_mem:m_axi_io:s_axi_ctrl:s_axi_dma} [get_bd_ports aclk]

    #=============================================
    # Create IP blocks
    #=============================================

    set freq 50
    puts "freq: $freq mhz"

    # Create instance: emu_clk_gen
    set emu_clk_gen [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 emu_clk_gen]
    set_property -dict [list \
        CONFIG.RESET_TYPE {ACTIVE_LOW} \
        CONFIG.CLKOUT1_REQUESTED_OUT_FREQ ${freq} \
        ] $emu_clk_gen

    # Create instance: emu_rst_gen
    set emu_rst_gen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 emu_rst_gen]

    # Create instance: emu_system
    set emu_system [create_bd_cell -type module -reference EMU_SYSTEM emu_system]
    set emu_system_axi_list [get_bd_intf_pins emu_system/EMU_AXI_*]
    lappend emu_system_axi_list [get_bd_intf_pins emu_system/EMU_SCAN_DMA_AXI]
    set emu_trace_dma_axi [get_bd_intf_pins emu_system/EMU_TRACE_DMA]
    if {[llength $emu_trace_dma_axi] > 0} {
        lappend emu_system_axi_list [get_bd_intf_pins emu_system/EMU_TRACE_DMA]
    }
    set m_axi_num [llength $emu_system_axi_list]

    set emu_system_dma_axi_list [get_bd_intf_pins emu_system/EMU_DMA_AXI_u_dmamodel_backend*]
    set axi_names {EMU_CTRL}
    foreach axi $emu_system_axi_list {
        append axi_names ":" [get_property NAME $axi]
    }
    foreach axi $emu_system_dma_axi_list {
        append axi_names ":" [get_property NAME $axi]
    }
    set_property -dict [list \
        CONFIG.ASSOCIATED_BUSIF $axi_names \
        ] [get_bd_pins emu_system/EMU_HOST_CLK]

    set_property -dict [list CONFIG.POLARITY {ACTIVE_HIGH}] [get_bd_pins emu_system/EMU_HOST_RST]

    # Create instance: axi_ctrl_ic
    set axi_ctrl_ic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ctrl_ic ]
    set_property -dict [list CONFIG.NUM_MI {1} CONFIG.NUM_SI {1}] $axi_ctrl_ic

    set axi_mmio_ic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mmio_ic ]
    set_property -dict [list CONFIG.NUM_MI {1} CONFIG.NUM_SI {1}] $axi_mmio_ic

    # Create instance: axi_mem_ic
    # IMPORTANT: CONFIG.STRATEGY must be set to instantiate crossbar in SASD mode for an AXI master interface without ID signal
    set axi_mem_ic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_ic ]
    set_property -dict [list CONFIG.NUM_MI {1} CONFIG.NUM_SI $m_axi_num CONFIG.STRATEGY {1} ] $axi_mem_ic

    set axi_dma_ic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_dma_ic ]
    set_property -dict [list CONFIG.NUM_MI {1} CONFIG.NUM_SI {1}] $axi_dma_ic

    set const_vcc [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_vcc ]
    set_property -dict [list CONFIG.CONST_WIDTH {1} CONFIG.CONST_VAL {0x1} ] $const_vcc

    # Create intr_sync
    set intr_sync [create_bd_cell -type module -reference f2s_rising_intr_sync intr_sync]
    set_property -dict [list \
        CONFIG.INTR_WIDTH {16} \
        CONFIG.SYNC_STAGE {2} \
        ] $intr_sync

    #=============================================
    # Misc ports
    #=============================================

    create_bd_port -dir I -from 15 -to 0 s2r_intr

    #=============================================
    # Misc interface connection
    #=============================================

    connect_bd_net [get_bd_ports s2r_intr] [get_bd_pins intr_sync/fast_intr]
    connect_bd_net [get_bd_pins intr_sync/slow_intr] [get_bd_pins emu_system/pcie_intr]
    #=============================================
    # System clock connection
    #=============================================

    connect_bd_net [get_bd_ports aclk] \
        [get_bd_pins emu_clk_gen/clk_in1] \
        [get_bd_pins axi_ctrl_ic/S00_ACLK] \
        [get_bd_pins axi_mmio_ic/M00_ACLK] \
        [get_bd_pins axi_mem_ic/M00_ACLK] \
        [get_bd_pins axi_ctrl_ic/ACLK] \
        [get_bd_pins axi_dma_ic/S00_ACLK] \
        [get_bd_pins axi_mem_ic/ACLK] \
        [get_bd_pins axi_dma_ic/ACLK]\
        [get_bd_pins axi_mmio_ic/ACLK]\
        [get_bd_pins intr_sync/fast_clk]

    connect_bd_net [get_bd_pins emu_clk_gen/clk_out1] \
        [get_bd_pins emu_rst_gen/slowest_sync_clk] \
        [get_bd_pins emu_system/EMU_HOST_CLK] \
        [get_bd_pins axi_ctrl_ic/M00_ACLK] \
        [get_bd_pins axi_mmio_ic/S00_ACLK] \
        [get_bd_pins axi_mem_ic/S*_ACLK] \
        [get_bd_pins axi_dma_ic/M00_ACLK] \
        [get_bd_pins intr_sync/slow_clk]

    #=============================================
    # System reset connection
    #=============================================

    connect_bd_net [get_bd_ports aresetn] \
        [get_bd_pins emu_clk_gen/resetn] \
        [get_bd_pins emu_rst_gen/ext_reset_in] \
        [get_bd_pins axi_ctrl_ic/S00_ARESETN] \
        [get_bd_pins axi_mmio_ic/M00_ARESETN] \
        [get_bd_pins axi_mem_ic/M00_ARESETN] \
        [get_bd_pins axi_dma_ic/S00_ARESETN] \
        [get_bd_pins axi_ctrl_ic/ARESETN] \
        [get_bd_pins axi_mem_ic/ARESETN] \
        [get_bd_pins axi_dma_ic/ARESETN] \
        [get_bd_pins axi_mmio_ic/ARESETN]

    connect_bd_net [get_bd_pins emu_clk_gen/locked] \
        [get_bd_pins emu_rst_gen/dcm_locked]

    connect_bd_net [get_bd_pins emu_rst_gen/peripheral_aresetn] \
        [get_bd_pins axi_ctrl_ic/M00_ARESETN] \
        [get_bd_pins axi_mmio_ic/S00_ARESETN] \
        [get_bd_pins axi_mem_ic/S*_ARESETN] \
        [get_bd_pins axi_dma_ic/M00_ARESETN]

    connect_bd_net [get_bd_pins emu_rst_gen/peripheral_reset] \
        [get_bd_pins emu_system/EMU_HOST_RST] \

        #=============================================
        # AXI interface connection
        #=============================================

        connect_bd_intf_net [get_bd_intf_ports s_axi_ctrl] [get_bd_intf_pins axi_ctrl_ic/S00_AXI]
    connect_bd_intf_net [get_bd_intf_pins axi_ctrl_ic/M00_AXI] [get_bd_intf_pins emu_system/EMU_CTRL]
    if {[llength $emu_system_dma_axi_list] > 0} {
        connect_bd_intf_net [get_bd_intf_pins emu_system/EMU_DMA_AXI_u_dmamodel_backend_host_mmio_axi] [get_bd_intf_pins axi_mmio_ic/S00_AXI]
        connect_bd_intf_net [get_bd_intf_pins axi_dma_ic/M00_AXI] [get_bd_intf_pins emu_system/EMU_DMA_AXI_u_dmamodel_backend_host_dma_axi]
    }
    connect_bd_intf_net [get_bd_intf_ports m_axi_io] [get_bd_intf_pins axi_mmio_ic/M00_AXI]
    connect_bd_intf_net [get_bd_intf_ports s_axi_dma] [get_bd_intf_pins axi_dma_ic/S00_AXI]

    # Create instance: system_ila, and set properties
    if {[llength $emu_system_dma_axi_list] > 0} {
        set system_ila [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila ]
        set_property -dict [ list \
            CONFIG.C_NUM_MONITOR_SLOTS {3} \
            ] $system_ila

        connect_bd_net [get_bd_pins emu_clk_gen/clk_out1] [get_bd_pins system_ila/clk]
        connect_bd_net [get_bd_pins emu_rst_gen/peripheral_aresetn] [get_bd_pins system_ila/resetn]

        connect_bd_intf_net [get_bd_intf_pins system_ila/SLOT_0_AXI] [get_bd_intf_pins emu_system/EMU_DMA_AXI_u_dmamodel_backend_host_mmio_axi]
        connect_bd_intf_net [get_bd_intf_pins system_ila/SLOT_1_AXI] [get_bd_intf_pins emu_system/EMU_DMA_AXI_u_dmamodel_backend_host_dma_axi]
        connect_bd_intf_net [get_bd_intf_pins system_ila/SLOT_2_AXI] [get_bd_intf_pins emu_system/EMU_AXI_u_rammodel_backend_host_axi]
    }

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
    if {[llength $emu_system_dma_axi_list] > 0} {
        create_bd_addr_seg -range 0x10000 -offset 0x0 [get_bd_addr_spaces s_axi_ctrl] [get_bd_addr_segs emu_system/EMU_CTRL/reg0] EMU_MMIO
        create_bd_addr_seg -offset 0x0 -range 0x1000000000 [get_bd_addr_spaces s_axi_dma] [get_bd_addr_segs emu_system/EMU_DMA_AXI_u_dmamodel_backend_host_dma_axi/reg0] EMU_DMA
    } else {
        set axi_reg_slice_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_reg_slice_dma ]
        set_property -dict [ list CONFIG.USE_AUTOPIPELINING {1} \
            CONFIG.ADDR_WIDTH {36} CONFIG.DATA_WIDTH {256} CONFIG.ID_WIDTH {4}] $axi_reg_slice_dma

        set axi_reg_slice_mmio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_register_slice:2.1 axi_reg_slice_mmio ]
        set_property -dict [ list CONFIG.USE_AUTOPIPELINING {1} \
            CONFIG.ADDR_WIDTH {32} CONFIG.DATA_WIDTH {32} ] $axi_reg_slice_mmio

        connect_bd_intf_net [get_bd_intf_pins axi_reg_slice_mmio/M_AXI] [get_bd_intf_pins axi_mmio_ic/S00_AXI]
        connect_bd_intf_net [get_bd_intf_pins axi_dma_ic/M00_AXI] [get_bd_intf_pins axi_reg_slice_dma/S_AXI]

        connect_bd_net [get_bd_pins emu_clk_gen/clk_out1] [get_bd_pins axi_reg_slice_mmio/aclk]
        connect_bd_net [get_bd_pins emu_rst_gen/peripheral_aresetn] [get_bd_pins axi_reg_slice_mmio/aresetn]
        connect_bd_net [get_bd_pins emu_clk_gen/clk_out1] [get_bd_pins axi_reg_slice_dma/aclk]
        connect_bd_net [get_bd_pins emu_rst_gen/peripheral_aresetn] [get_bd_pins axi_reg_slice_dma/aresetn]
    }

    #=============================================
    # Finish BD creation
    #=============================================

    save_bd_design

}

# add source HDL files
set remu_install_prefix ${script_dir}/../../tools/remu/install
add_files -fileset sources_1 ${design_dir}/../hardware/remu_out/emu_system.v
add_files -fileset sources_1 [exec ${remu_install_prefix}/bin/remu-config --includes]
add_files -fileset sources_1 [exec ${remu_install_prefix}/bin/remu-config --plat xilinx --sources]
add_files -fileset sources_1 ${design_dir}/../hardware/remu_out/TraceBackend.v
add_files -fileset sources_1 ${design_dir}/../hardware/remu_out/emu_clock_model.v
add_files -fileset sources_1 ${design_dir}/../fpga/sources/wrapper/role_top_remu.v
add_files -fileset sources_1 ${design_dir}/../fpga/sources/hdl/

set bd_design role
create_design ${bd_design}

set_property synth_checkpoint_mode None [get_files ${bd_design}.bd]
generate_target all [get_files ${bd_design}.bd]

validate_bd_design
save_bd_design
close_bd_design ${bd_design}

set_property top role_top [get_filesets sources_1]
