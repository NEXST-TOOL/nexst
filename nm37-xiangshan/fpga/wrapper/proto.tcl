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
        CONFIG.DATA_WIDTH {512} ] $m_axi_mem

    set m_axi_io [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_io]
    set_property -dict [ list CONFIG.PROTOCOL {AXI4} \
        CONFIG.ADDR_WIDTH {32} \
        CONFIG.DATA_WIDTH {32} ] $m_axi_io

    set s_axi_ctrl [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ctrl]
    set_property -dict [ list CONFIG.PROTOCOL {AXI4Lite} \
        CONFIG.ADDR_WIDTH {20} \
        CONFIG.DATA_WIDTH {32} ] $s_axi_ctrl

    set s_axi_dma [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_dma]
    set_property -dict [ list CONFIG.PROTOCOL {AXI4} \
        CONFIG.ADDR_WIDTH {36} \
        CONFIG.DATA_WIDTH {128} ] $s_axi_dma

    set_property CONFIG.ASSOCIATED_BUSIF {m_axi_mem:m_axi_io:s_axi_ctrl:s_axi_dma} [get_bd_ports aclk]

    #=============================================
    # Create IP blocks
    #=============================================

    # Create instance: xs_top
    set xs_top [create_bd_cell -type module -reference XSTop xs_top]
    set_property -dict [list \
        CONFIG.ASSOCIATED_BUSIF {dma_0:peripheral_0:memory_0} \
    ] [get_bd_pins xs_top/io_clock]

    # Create GPIO register to generate reset signal
    set gpio_reset [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_reset]
    set_property -dict [list \
        CONFIG.C_GPIO_WIDTH {1} \
        CONFIG.C_DOUT_DEFAULT {0x00000001} \
        CONFIG.C_ALL_OUTPUTS {1} \
    ] $gpio_reset

    # Create AXI data width converters
    set mem_axi_adapter [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 mem_axi_adapter]
    set io_axi_adapter [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 io_axi_adapter]
    set dma_axi_adapter [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dwidth_converter:2.1 dma_axi_adapter]

    #=============================================
    # System clock connection
    #=============================================

    connect_bd_net [get_bd_ports aclk] \
        [get_bd_pins xs_top/io_clock] \
        [get_bd_pins gpio_reset/s_axi_aclk] \
        [get_bd_pins mem_axi_adapter/s_axi_aclk] \
        [get_bd_pins io_axi_adapter/s_axi_aclk] \
        [get_bd_pins dma_axi_adapter/s_axi_aclk]

    #=============================================
    # System reset connection
    #=============================================

    connect_bd_net [get_bd_ports aresetn] \
        [get_bd_pins gpio_reset/s_axi_aresetn] \
        [get_bd_pins mem_axi_adapter/s_axi_aresetn] \
        [get_bd_pins io_axi_adapter/s_axi_aresetn] \
        [get_bd_pins dma_axi_adapter/s_axi_aresetn]

    connect_bd_net [get_bd_pins gpio_reset/gpio_io_o] \
        [get_bd_pins xs_top/io_reset]

    #=============================================
    # AXI interface connection
    #=============================================

    connect_bd_intf_net [get_bd_intf_ports s_axi_ctrl] \
        [get_bd_intf_pins gpio_reset/S_AXI]

    # Address mapper for MEM AXI
    # Bits 35:34 are wired to 0

    set const_2b0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_2b0 ]
    set_property -dict [list CONFIG.CONST_WIDTH {2} CONFIG.CONST_VAL {0x0} ] $const_2b0

    set pair_list [list \
        {xs_top memory_0_araddr mem_axi_adapter s_axi_araddr} \
        {xs_top memory_0_awaddr mem_axi_adapter s_axi_awaddr} \
    ]

    foreach pair ${pair_list} {
        set src_blk   [lindex ${pair} 0]
        set src_port  [lindex ${pair} 1]
        set dst_blk   [lindex ${pair} 2]
        set dst_port  [lindex ${pair} 3]

        set slice [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_${src_blk}_${src_port} ]
        set_property -dict [list CONFIG.DIN_WIDTH {36} CONFIG.DIN_FROM {33} CONFIG.DIN_TO {0}] $slice

        set concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_${dst_blk}_${dst_port} ]
        set_property -dict [list CONFIG.NUM_PORTS {2}] $concat

        connect_bd_net [get_bd_pins ${src_blk}/${src_port}] [get_bd_pins ${slice}/Din]
        connect_bd_net [get_bd_pins ${slice}/Dout] [get_bd_pins ${concat}/In0]
        connect_bd_net [get_bd_pins const_2b0/dout] [get_bd_pins ${concat}/In1]
        connect_bd_net [get_bd_pins ${concat}/dout] [get_bd_pins ${dst_blk}/${dst_port}]
    }

    # MEM AXI connection

    connect_bd_intf_net [get_bd_intf_pins xs_top/memory_0] \
        [get_bd_intf_pins mem_axi_adapter/S_AXI]

    connect_bd_intf_net [get_bd_intf_pins mem_axi_adapter/M_AXI] \
        [get_bd_intf_ports m_axi_mem]

    # MMIO AXI connection

    connect_bd_intf_net [get_bd_intf_pins xs_top/peripheral_0] \
        [get_bd_intf_pins io_axi_adapter/S_AXI]

    connect_bd_intf_net [get_bd_intf_pins io_axi_adapter/M_AXI] \
        [get_bd_intf_ports m_axi_io]

    # DMA AXI connection

    connect_bd_intf_net [get_bd_intf_ports s_axi_dma] \
        [get_bd_intf_pins dma_axi_adapter/S_AXI]

    connect_bd_intf_net [get_bd_intf_pins dma_axi_adapter/M_AXI] \
        [get_bd_intf_pins xs_top/dma_0]

    #=============================================
    # Create address segments
    #=============================================

    assign_bd_address -offset 0x0 -range 0x00010000 -target_address_space [get_bd_addr_spaces s_axi_ctrl] [get_bd_addr_segs gpio_reset/S_AXI/Reg] -force
    assign_bd_address -offset 0x0 -range 0x1000000000 -target_address_space [get_bd_addr_spaces s_axi_dma] [get_bd_addr_segs xs_top/dma_0/reg0] -force
    assign_bd_address -offset 0x0 -range 0x1000000000 -target_address_space [get_bd_addr_spaces xs_top/memory_0] [get_bd_addr_segs m_axi_mem/Reg] -force
    assign_bd_address -offset 0x0 -range 0x100000000 -target_address_space [get_bd_addr_spaces xs_top/peripheral_0] [get_bd_addr_segs m_axi_io/Reg] -force

    #=============================================
    # Finish BD creation 
    #=============================================

    save_bd_design

}

# add source HDL files
add_files -norecurse -fileset sources_1 ${design_dir}/../hardware/sources/generated/
add_files -norecurse -fileset sources_1 ${design_dir}/../hardware/sources/hdl/
add_files -norecurse -fileset sources_1 ${design_dir}/../fpga/sources/hdl/role_top.v

# clear IP catalog
# update_ip_catalog -clear_ip_cache
check_ip_cache -clear_output_repo

set bd_design role
create_design ${bd_design}

set_property synth_checkpoint_mode None [get_files ${bd_design}.bd]
generate_target all [get_files ${bd_design}.bd]

#make_wrapper -top -import [get_files ${bd_design}.bd]

validate_bd_design
save_bd_design
close_bd_design ${bd_design}

set_property top role_top [get_filesets sources_1]
