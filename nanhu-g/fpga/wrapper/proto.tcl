proc create_design { design_name } {

    create_bd_design ${design_name}
    current_bd_design ${design_name}

    #=============================================
    # Clock ports
    #=============================================

    create_bd_port -dir I -type clk -freq_hz 30000000 aclk

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
        CONFIG.DATA_WIDTH {256} ] $m_axi_mem

    set m_axi_io [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_io]
    set_property -dict [ list CONFIG.PROTOCOL {AXI4} \
        CONFIG.ADDR_WIDTH {31} \
        CONFIG.DATA_WIDTH {64} ] $m_axi_io

    set s_axi_ctrl [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_ctrl]
    set_property -dict [ list CONFIG.PROTOCOL {AXI4Lite} \
        CONFIG.ADDR_WIDTH {20} \
        CONFIG.DATA_WIDTH {32} ] $s_axi_ctrl

    set s_axi_dma [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi_dma]
    set_property -dict [ list CONFIG.PROTOCOL {AXI4} \
        CONFIG.ADDR_WIDTH {48} \
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
	CONFIG.C_DOUT_DEFAULT_2 {0x80000000} \
  	CONFIG.C_IS_DUAL {1} \
] $gpio_reset


    # Create AXI Interconnects
#    set axi_ctrl_ic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_ctrl_ic ]
#    set_property -dict [list CONFIG.NUM_MI {1} CONFIG.NUM_SI {1}] $axi_ctrl_ic

#    set axi_dma_ic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_dma_ic ]
#    set_property -dict [list CONFIG.NUM_MI {1} CONFIG.NUM_SI {1}] $axi_dma_ic

#    set axi_io_ic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_io_ic ]
#    set_property -dict [list CONFIG.NUM_MI {1} CONFIG.NUM_SI {1}] $axi_io_ic

#    set axi_mem_ic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_ic ]
#    set_property -dict [list CONFIG.NUM_MI {1} CONFIG.NUM_SI {1}] $axi_mem_ic

    # Create AXI ID removers
    set mem_axi_id_remover [create_bd_cell -type module -reference axi_id_killer mem_axi_id_remover]
    set_property -dict [list \
        CONFIG.ADDR_WIDTH {36} \
        CONFIG.DATA_WIDTH {256} \
        CONFIG.ID_WIDTH {14} \
    ] $mem_axi_id_remover

    # Create intr_sync
#    set intr_sync [create_bd_cell -type module -reference f2s_rising_intr_sync intr_sync]
#    set_property -dict [list \
#        CONFIG.INTR_WIDTH {16} \
#        CONFIG.SYNC_STAGE {2} \
#    ] $intr_sync

    #=============================================
    # System clock connection
    #=============================================

    connect_bd_net [get_bd_ports aclk] \
        [get_bd_pins xs_top/io_clock] \
        [get_bd_pins gpio_reset/s_axi_aclk] \
        [get_bd_pins mem_axi_id_remover/aclk]
#        [get_bd_pins intr_sync/fast_clk] \
#        [get_bd_pins intr_sync/slow_clk]
#        [get_bd_pins axi_ctrl_ic/ACLK] \
#        [get_bd_pins axi_ctrl_ic/S00_ACLK] \
#        [get_bd_pins axi_dma_ic/ACLK] \
#        [get_bd_pins axi_dma_ic/S00_ACLK] \
#        [get_bd_pins axi_io_ic/ACLK] \
#        [get_bd_pins axi_io_ic/M00_ACLK] \
#        [get_bd_pins axi_mem_ic/ACLK] \
#        [get_bd_pins axi_mem_ic/M00_ACLK] \
#        [get_bd_pins axi_ctrl_ic/M00_ACLK] \
#        [get_bd_pins axi_dma_ic/M00_ACLK] \
#        [get_bd_pins axi_io_ic/S00_ACLK] \
#        [get_bd_pins axi_mem_ic/S00_ACLK] \
#
    connect_bd_net [get_bd_ports rtc_clock] \
        [get_bd_pins xs_top/io_rtc_clock] \

    #=============================================
    # System reset connection
    #=============================================

    connect_bd_net [get_bd_ports aresetn] \
        [get_bd_pins gpio_reset/s_axi_aresetn] \
        [get_bd_pins mem_axi_id_remover/aresetn]

    connect_bd_net [get_bd_pins gpio_reset/gpio_io_o] \
        [get_bd_pins xs_top/io_reset]

#        [get_bd_pins axi_ctrl_ic/ARESETN] \
#        [get_bd_pins axi_ctrl_ic/S00_ARESETN] \
#        [get_bd_pins axi_dma_ic/ARESETN] \
#        [get_bd_pins axi_dma_ic/S00_ARESETN] \
#        [get_bd_pins axi_io_ic/ARESETN] \
#        [get_bd_pins axi_io_ic/M00_ARESETN] \
#        [get_bd_pins axi_mem_ic/ARESETN] \
#        [get_bd_pins axi_mem_ic/M00_ARESETN]

#    connect_bd_net [get_bd_pins emu_rst_gen/peripheral_aresetn] \
#        [get_bd_pins axi_ctrl_ic/M00_ARESETN] \
#        [get_bd_pins axi_dma_ic/M00_ARESETN] \
#        [get_bd_pins axi_io_ic/S00_ARESETN] \
#        [get_bd_pins axi_mem_ic/S00_ARESETN] \
#        [get_bd_pins gpio_reset/s_axi_aresetn] \
#        [get_bd_pins mem_axi_id_remover/aresetn]


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
        {xs_top memory_araddr mem_axi_id_remover s_axi_araddr} \
        {xs_top memory_awaddr mem_axi_id_remover s_axi_awaddr} \
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

    connect_bd_intf_net [get_bd_intf_pins xs_top/memory] \
        [get_bd_intf_pins mem_axi_id_remover/s_axi]

    connect_bd_intf_net [get_bd_intf_pins mem_axi_id_remover/m_axi] \
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

    create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0
    set_property -dict [list \
  CONFIG.CONST_VAL {80000000} \
  CONFIG.CONST_WIDTH {48} \
] [get_bd_cells xlconstant_0]
connect_bd_net [get_bd_pins xlconstant_0/dout] [get_bd_pins xs_top/io_riscv_rst_vec_0]

	

    create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0
    set_property -dict [list \
  CONFIG.C_MON_TYPE {NATIVE} \
  CONFIG.C_NUM_OF_PROBES {9} \
] [get_bd_cells system_ila_0]

connect_bd_net [get_bd_ports aclk] [get_bd_pins system_ila_0/clk]
connect_bd_net [get_bd_pins system_ila_0/probe0] [get_bd_pins xs_top/io_riscv_halt_0]
connect_bd_net [get_bd_pins system_ila_0/probe1] [get_bd_pins xs_top/io_riscv_critical_error_0]
connect_bd_net [get_bd_pins system_ila_0/probe2] [get_bd_pins xs_top/io_traceCoreInterface_0_toEncoder_cause]
connect_bd_net [get_bd_pins system_ila_0/probe3] [get_bd_pins xs_top/io_traceCoreInterface_0_toEncoder_tval]
connect_bd_net [get_bd_pins system_ila_0/probe4] [get_bd_pins xs_top/io_traceCoreInterface_0_toEncoder_priv]
connect_bd_net [get_bd_pins system_ila_0/probe5] [get_bd_pins xs_top/io_traceCoreInterface_0_toEncoder_iaddr]
connect_bd_net [get_bd_pins system_ila_0/probe6] [get_bd_pins xs_top/io_traceCoreInterface_0_toEncoder_itype]
connect_bd_net [get_bd_pins system_ila_0/probe7] [get_bd_pins xs_top/io_traceCoreInterface_0_toEncoder_iretire]
connect_bd_net [get_bd_pins system_ila_0/probe8] [get_bd_pins xs_top/io_traceCoreInterface_0_toEncoder_ilastsize]

delete_bd_objs [get_bd_nets xlconstant_0_dout] [get_bd_cells xlconstant_0]
connect_bd_net [get_bd_pins xs_top/io_riscv_rst_vec_0] [get_bd_pins gpio_reset/gpio2_io_o]

    #=============================================
    # Create address segments
    #=============================================

    assign_bd_address -offset 0x0 -range 0x00010000 -target_address_space [get_bd_addr_spaces s_axi_ctrl] [get_bd_addr_segs gpio_reset/S_AXI/Reg] -force
    assign_bd_address -offset 0x0 -range 0x1000000000 -target_address_space [get_bd_addr_spaces s_axi_dma] [get_bd_addr_segs xs_top/dma/reg0] -force
    assign_bd_address -offset 0x0 -range 0x80000000 -target_address_space [get_bd_addr_spaces xs_top/peripheral] [get_bd_addr_segs m_axi_io/Reg] -force

    assign_bd_address -offset 0x0 -range 0x1000000000 -target_address_space [get_bd_addr_spaces xs_top/memory] [get_bd_addr_segs mem_axi_id_remover/s_axi/reg0] -force
    assign_bd_address -offset 0x0 -range 0x1000000000 -target_address_space [get_bd_addr_spaces mem_axi_id_remover/m_axi] [get_bd_addr_segs m_axi_mem/Reg] -force

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
