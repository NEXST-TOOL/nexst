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
        CONFIG.ADDR_WIDTH {48} \
        CONFIG.ID_WIDTH {14} \
        CONFIG.DATA_WIDTH {256} ] $m_axi_mem

    set m_axi_io [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_io]
    set_property -dict [ list CONFIG.PROTOCOL {AXI4} \
        CONFIG.ADDR_WIDTH {37} \
        CONFIG.ID_WIDTH {4} \
        CONFIG.DATA_WIDTH {64} ] $m_axi_io

    set s_axi_ctrl [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ctrl]
    set_property -dict [ list CONFIG.PROTOCOL {AXI4Lite} \
        CONFIG.ADDR_WIDTH {20} \
        CONFIG.DATA_WIDTH {32} ] $s_axi_ctrl

    set s_axi_dma [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_dma]
    set_property -dict [ list CONFIG.PROTOCOL {AXI4} \
        CONFIG.ADDR_WIDTH {36} \
        CONFIG.ID_WIDTH {12} \
        CONFIG.DATA_WIDTH {256} ] $s_axi_dma

    set_property CONFIG.ASSOCIATED_BUSIF {m_axi_mem:m_axi_io:s_axi_ctrl:s_axi_dma} [get_bd_ports aclk]

    #=============================================
    # Misc ports
    #=============================================

    create_bd_port -dir I -from 63 -to 0 s2r_intr

    #=============================================
    # Create IP blocks
    #=============================================

    # Create instance: xs_top
    set xs_top [create_bd_cell -type module -reference XSTop xs_top]
    set_property -dict [list \
        CONFIG.ASSOCIATED_BUSIF {dma:peripheral:memory} \
        ] [get_bd_pins xs_top/io_clock]

    # Create GPIO register to generate reset signal
    set gpio_reset [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_reset]
    set_property -dict [list \
        CONFIG.C_GPIO_WIDTH {1} \
        CONFIG.C_DOUT_DEFAULT {0x00000001} \
        CONFIG.C_ALL_OUTPUTS {1} \
        CONFIG.C_ALL_OUTPUTS_2 {1} \
        CONFIG.C_DOUT_DEFAULT_2 {0x10000000} \
        CONFIG.C_IS_DUAL {1} \
        ] $gpio_reset

    #=============================================
    # System clock connection
    #=============================================

    connect_bd_net [get_bd_ports aclk] \
        [get_bd_pins xs_top/io_clock] \
        [get_bd_pins gpio_reset/s_axi_aclk]

    connect_bd_net [get_bd_ports rtc_clock] \
        [get_bd_pins xs_top/io_rtc_clock]

    #=============================================
    # System reset connection
    #=============================================

    connect_bd_net [get_bd_ports aresetn] \
        [get_bd_pins gpio_reset/s_axi_aresetn]

    connect_bd_net [get_bd_pins gpio_reset/gpio_io_o] \
        [get_bd_pins xs_top/io_reset]

    #=============================================
    # AXI interface connection
    #=============================================

    connect_bd_intf_net [get_bd_intf_ports s_axi_ctrl] \
        [get_bd_intf_pins gpio_reset/S_AXI]

    # MEM AXI connection
    connect_bd_intf_net [get_bd_intf_pins xs_top/memory] \
        [get_bd_intf_ports m_axi_mem]

    # MMIO AXI connection
    connect_bd_intf_net [get_bd_intf_pins xs_top/peripheral] \
        [get_bd_intf_ports m_axi_io]

    # DMA AXI connection
    connect_bd_intf_net [get_bd_intf_ports s_axi_dma] \
        [get_bd_intf_pins xs_top/dma]

    #=============================================
    # Misc interface connection
    #=============================================

    connect_bd_net [get_bd_ports s2r_intr] [get_bd_pins xs_top/io_extIntrs]

    connect_bd_net [get_bd_pins xs_top/io_riscv_rst_vec_0] [get_bd_pins gpio_reset/gpio2_io_o]

    #=============================================
    # Create address segments
    #=============================================

    assign_bd_address -offset 0x0 -range 0x00010000 -target_address_space [get_bd_addr_spaces s_axi_ctrl] [get_bd_addr_segs gpio_reset/S_AXI/Reg] -force
    assign_bd_address -offset 0x0 -range 0x1000000000 -target_address_space [get_bd_addr_spaces s_axi_dma] [get_bd_addr_segs xs_top/dma/reg0] -force
    assign_bd_address -offset 0x0 -range 0x80000000 -target_address_space [get_bd_addr_spaces xs_top/peripheral] [get_bd_addr_segs m_axi_io/Reg] -force

    assign_bd_address -offset 0x0 -range 0x1000000000 -target_address_space [get_bd_addr_spaces xs_top/memory] [get_bd_addr_segs m_axi_mem/Reg] -force

    #=============================================
    # Add ilas
    #=============================================
    create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0
    set_property -dict [list \
        CONFIG.C_MON_TYPE {NATIVE} \
        CONFIG.C_NUM_OF_PROBES {11} \
        ] [get_bd_cells system_ila_0]

    connect_bd_net [get_bd_ports aclk] [get_bd_pins system_ila_0/clk]
    connect_bd_net [get_bd_pins system_ila_0/probe0] [get_bd_pins xs_top/riscv_halt]
    connect_bd_net [get_bd_pins system_ila_0/probe1] [get_bd_pins xs_top/riscv_critical_error]
    connect_bd_net [get_bd_pins system_ila_0/probe2] [get_bd_pins xs_top/trace_cause]
    connect_bd_net [get_bd_pins system_ila_0/probe3] [get_bd_pins xs_top/trace_tval]
    connect_bd_net [get_bd_pins system_ila_0/probe4] [get_bd_pins xs_top/trace_priv]
    connect_bd_net [get_bd_pins system_ila_0/probe5] [get_bd_pins xs_top/trace_iaddr0]
    connect_bd_net [get_bd_pins system_ila_0/probe6] [get_bd_pins xs_top/trace_iaddr1]
    connect_bd_net [get_bd_pins system_ila_0/probe7] [get_bd_pins xs_top/trace_iaddr2]
    connect_bd_net [get_bd_pins system_ila_0/probe8] [get_bd_pins xs_top/trace_itype]
    connect_bd_net [get_bd_pins system_ila_0/probe9] [get_bd_pins xs_top/trace_iretire]
    connect_bd_net [get_bd_pins system_ila_0/probe10] [get_bd_pins xs_top/trace_ilastsize]

    #=============================================
    # Finish BD creation
    #=============================================

    save_bd_design

}

# add source HDL files
add_files -fileset sources_1 ${design_dir}/../hardware/sources/generated/
add_files -fileset sources_1 ${design_dir}/../fpga/sources/hdl/
add_files -fileset sources_1 ${design_dir}/../fpga/sources/wrapper/role_top_proto.v

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
