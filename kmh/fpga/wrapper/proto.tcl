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
        CONFIG.ADDR_WIDTH {24} \
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
    set xs_top [create_bd_cell -type module -reference xstop_wrapper xs_top]
    set_property -dict [list \
        CONFIG.ASSOCIATED_BUSIF {peripheral:memory} \
        ] [get_bd_pins xs_top/clk]

    set axil_jtag_bridge [create_bd_cell -type module -reference axi_lite_jtag_bridge axil_jtag_bridge]

    set ctrl_ic [create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 ctrl_ic]
    set_property -dict [list \
        CONFIG.NUM_MI {4} \
        CONFIG.NUM_SI {1} \
        ] $ctrl_ic

    set io_ic [create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 io_ic]
    set_property -dict [list \
        CONFIG.NUM_MI {3} \
        CONFIG.NUM_SI {1} \
        ] $io_ic

    # Create AXI UART Lite for host-side access
    set host_uart [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 host_uart]
    set_property CONFIG.C_BAUDRATE {115200} $host_uart

    # Create AXI UART Lite for the role
    set role_uart [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 role_uart]
    set_property CONFIG.C_BAUDRATE {115200} $role_uart

    # Create dual-port Boot ROM memory
    set bootrom_bram [create_bd_cell -type ip -vlnv xilinx.com:ip:emb_mem_gen:1.0 bootrom_bram]
    set_property -dict [list \
        CONFIG.MEMORY_PRIMITIVE {URAM} \
        CONFIG.MEMORY_TYPE {True_Dual_Port_RAM} \
        ] $bootrom_bram

    # Create the host/control-side Boot ROM controller
    set dut_bootrom_ctrl [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 dut_bootrom_ctrl]
    set_property -dict [list \
        CONFIG.PROTOCOL {AXI4} \
        CONFIG.SINGLE_PORT_BRAM {1} \
        ] $dut_bootrom_ctrl

    # Create interrupt vector glue:
    #   bits [31:0]  - role-internal interrupts
    #   bits [63:32] - shell interrupts [31:0]
    set uart_intr_zero_low [create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 uart_intr_zero_low]
    set_property -dict [list \
        CONFIG.CONST_VAL {0x0} \
        CONFIG.CONST_WIDTH {3} \
        ] $uart_intr_zero_low

    set uart_intr_zero_high [create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 uart_intr_zero_high]
    set_property -dict [list \
        CONFIG.CONST_VAL {0x0} \
        CONFIG.CONST_WIDTH {28} \
        ] $uart_intr_zero_high

    set shell_intr_slice [create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 shell_intr_slice]
    set_property -dict [list \
        CONFIG.DIN_WIDTH {64} \
        CONFIG.DIN_FROM {31} \
        CONFIG.DIN_TO {0} \
        ] $shell_intr_slice

    set intr_concat [create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat:1.0 intr_concat]
    set_property -dict [list \
        CONFIG.NUM_PORTS {4} \
        CONFIG.IN0_WIDTH {3} \
        CONFIG.IN1_WIDTH {1} \
        CONFIG.IN2_WIDTH {28} \
        CONFIG.IN3_WIDTH {32} \
        ] $intr_concat

    # Create the role/peripheral-side Boot ROM controller
    set user_bootrom_ctrl [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 user_bootrom_ctrl]
    set_property CONFIG.SINGLE_PORT_BRAM {1} $user_bootrom_ctrl

    # Create GPIO register to generate reset signal
    set gpio_reset [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio gpio_reset]
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
        [get_bd_pins xs_top/clk] \
        [get_bd_pins gpio_reset/s_axi_aclk] \
        [get_bd_pins axil_jtag_bridge/s_axi_aclk] \
        [get_bd_pins ctrl_ic/aclk] \
        [get_bd_pins io_ic/aclk] \
        [get_bd_pins host_uart/s_axi_aclk] \
        [get_bd_pins role_uart/s_axi_aclk] \
        [get_bd_pins dut_bootrom_ctrl/s_axi_aclk] \
        [get_bd_pins user_bootrom_ctrl/s_axi_aclk]

    connect_bd_net [get_bd_ports rtc_clock] \
        [get_bd_pins xs_top/rtc_clk]

    #=============================================
    # System reset connection
    #=============================================

    connect_bd_net [get_bd_ports aresetn] \
        [get_bd_pins gpio_reset/s_axi_aresetn] \
        [get_bd_pins axil_jtag_bridge/s_axi_aresetn] \
        [get_bd_pins ctrl_ic/aresetn] \
        [get_bd_pins io_ic/aresetn] \
        [get_bd_pins host_uart/s_axi_aresetn] \
        [get_bd_pins role_uart/s_axi_aresetn] \
        [get_bd_pins dut_bootrom_ctrl/s_axi_aresetn] \
        [get_bd_pins user_bootrom_ctrl/s_axi_aresetn]

    connect_bd_net [get_bd_pins gpio_reset/gpio_io_o] \
        [get_bd_pins xs_top/rst]

    #=============================================
    # AXI interface connection
    #=============================================

    connect_bd_intf_net [get_bd_intf_ports s_axi_ctrl] \
        [get_bd_intf_pins ctrl_ic/S00_AXI]

    connect_bd_intf_net [get_bd_intf_pins ctrl_ic/M00_AXI] \
        [get_bd_intf_pins gpio_reset/S_AXI]

    connect_bd_intf_net [get_bd_intf_pins ctrl_ic/M01_AXI] \
        [get_bd_intf_pins axil_jtag_bridge/S_AXI]

    connect_bd_intf_net [get_bd_intf_pins ctrl_ic/M02_AXI] \
        [get_bd_intf_pins dut_bootrom_ctrl/S_AXI]

    connect_bd_intf_net [get_bd_intf_pins ctrl_ic/M03_AXI] \
        [get_bd_intf_pins host_uart/S_AXI]

    # MEM AXI connection
    connect_bd_intf_net [get_bd_intf_pins xs_top/memory] \
        [get_bd_intf_ports m_axi_mem]

    # MMIO AXI connection
    connect_bd_intf_net [get_bd_intf_pins xs_top/peripheral] \
        [get_bd_intf_pins io_ic/S00_AXI]

    connect_bd_intf_net [get_bd_intf_pins io_ic/M00_AXI] \
        [get_bd_intf_ports m_axi_io]

    connect_bd_intf_net [get_bd_intf_pins io_ic/M01_AXI] \
        [get_bd_intf_pins user_bootrom_ctrl/S_AXI]

    connect_bd_intf_net [get_bd_intf_pins io_ic/M02_AXI] \
        [get_bd_intf_pins role_uart/S_AXI]

    connect_bd_intf_net [get_bd_intf_pins dut_bootrom_ctrl/BRAM_PORTA] \
        [get_bd_intf_pins bootrom_bram/BRAM_PORTA]

    connect_bd_intf_net [get_bd_intf_pins user_bootrom_ctrl/BRAM_PORTA] \
        [get_bd_intf_pins bootrom_bram/BRAM_PORTB]

    #=============================================
    # Misc interface connection
    #=============================================

    connect_bd_net [get_bd_pins role_uart/tx] [get_bd_pins host_uart/rx]
    connect_bd_net [get_bd_pins host_uart/tx] [get_bd_pins role_uart/rx]
    # ilconcat maps In0 to the least-significant bits:
    #   intr_concat/dout = {s2r_intr[31:0], 28'b0, role_uart/interrupt, 3'b0}

    connect_bd_net [get_bd_pins uart_intr_zero_low/dout] [get_bd_pins intr_concat/In0]
    connect_bd_net [get_bd_pins role_uart/interrupt] [get_bd_pins intr_concat/In1]
    connect_bd_net [get_bd_pins uart_intr_zero_high/dout] [get_bd_pins intr_concat/In2]
    connect_bd_net [get_bd_ports s2r_intr] [get_bd_pins shell_intr_slice/Din]
    connect_bd_net [get_bd_pins shell_intr_slice/Dout] [get_bd_pins intr_concat/In3]
    connect_bd_net [get_bd_pins intr_concat/dout] [get_bd_pins xs_top/ext_intrs]

    connect_bd_net [get_bd_pins xs_top/rst_vec] [get_bd_pins gpio_reset/gpio2_io_o]

    connect_bd_net [get_bd_pins xs_top/jtag_tdo_data] [get_bd_pins axil_jtag_bridge/jtag_tdo_data]
    connect_bd_net [get_bd_pins xs_top/jtag_tdo_driven] [get_bd_pins axil_jtag_bridge/jtag_tdo_driven]
    connect_bd_net [get_bd_pins xs_top/jtag_tck] [get_bd_pins axil_jtag_bridge/jtag_tck]
    connect_bd_net [get_bd_pins xs_top/jtag_tms] [get_bd_pins axil_jtag_bridge/jtag_tms]
    connect_bd_net [get_bd_pins xs_top/jtag_tdi] [get_bd_pins axil_jtag_bridge/jtag_tdi]
    connect_bd_net [get_bd_pins xs_top/jtag_reset] [get_bd_pins axil_jtag_bridge/jtag_reset]
    connect_bd_net [get_bd_pins xs_top/jtag_mfr_id] [get_bd_pins axil_jtag_bridge/jtag_mfr_id]
    connect_bd_net [get_bd_pins xs_top/jtag_part_number] [get_bd_pins axil_jtag_bridge/jtag_part_number]
    connect_bd_net [get_bd_pins xs_top/jtag_version] [get_bd_pins axil_jtag_bridge/jtag_version]

    #=============================================
    # Create address segments
    #=============================================

    # Create address segments
    assign_bd_address -offset 0x00000000 -range 0x001000000000 \
        -target_address_space [get_bd_addr_spaces xs_top/memory] \
        [get_bd_addr_segs m_axi_mem/Reg] -force

    assign_bd_address -external -dict [list \
        offset 0x00000000 range 0x10000000 name SEG_m_axi_io_Reg \
        offset 0x10010000 range 0x00010000 name SEG_m_axi_io_Reg_1 \
        offset 0x10020000 range 0x00020000 name SEG_m_axi_io_Reg_2 \
        offset 0x10040000 range 0x00040000 name SEG_m_axi_io_Reg_3 \
        offset 0x10080000 range 0x00080000 name SEG_m_axi_io_Reg_4 \
        offset 0x10100000 range 0x00100000 name SEG_m_axi_io_Reg_5 \
        offset 0x10200000 range 0x00200000 name SEG_m_axi_io_Reg_6 \
        offset 0x10400000 range 0x00400000 name SEG_m_axi_io_Reg_7 \
        offset 0x10800000 range 0x00800000 name SEG_m_axi_io_Reg_8 \
        offset 0x11000000 range 0x01000000 name SEG_m_axi_io_Reg_9 \
        offset 0x12000000 range 0x02000000 name SEG_m_axi_io_Reg_10 \
        offset 0x14000000 range 0x04000000 name SEG_m_axi_io_Reg_11 \
        offset 0x18000000 range 0x08000000 name SEG_m_axi_io_Reg_12 \
        offset 0x20000000 range 0x20000000 name SEG_m_axi_io_Reg_13 \
        offset 0x40000000 range 0x00400000 name SEG_m_axi_io_Reg_14 \
        offset 0x40400000 range 0x00200000 name SEG_m_axi_io_Reg_15 \
        offset 0x40610000 range 0x00010000 name SEG_m_axi_io_Reg_16 \
        offset 0x40620000 range 0x00020000 name SEG_m_axi_io_Reg_17 \
        offset 0x40640000 range 0x00040000 name SEG_m_axi_io_Reg_18 \
        offset 0x40680000 range 0x00080000 name SEG_m_axi_io_Reg_19 \
        offset 0x40700000 range 0x00100000 name SEG_m_axi_io_Reg_20 \
        offset 0x40800000 range 0x00800000 name SEG_m_axi_io_Reg_21 \
        offset 0x41000000 range 0x01000000 name SEG_m_axi_io_Reg_22 \
        offset 0x42000000 range 0x02000000 name SEG_m_axi_io_Reg_23 \
        offset 0x44000000 range 0x04000000 name SEG_m_axi_io_Reg_24 \
        offset 0x48000000 range 0x08000000 name SEG_m_axi_io_Reg_25 \
        offset 0x50000000 range 0x10000000 name SEG_m_axi_io_Reg_26 \
        offset 0x60000000 range 0x20000000 name SEG_m_axi_io_Reg_27 \
        ] -target_address_space [get_bd_addr_spaces xs_top/peripheral] \
        [get_bd_addr_segs m_axi_io/Reg] -force

    # Boot ROM and UART Lite are part of the role MMIO map.
    assign_bd_address -offset 0x10000000 -range 0x00010000 \
        -target_address_space [get_bd_addr_spaces xs_top/peripheral] \
        [get_bd_addr_segs user_bootrom_ctrl/S_AXI/Mem0] -force
    assign_bd_address -offset 0x40600000 -range 0x00010000 \
        -with_name XS_UARTLITE \
        -target_address_space [get_bd_addr_spaces xs_top/peripheral] \
        [get_bd_addr_segs role_uart/S_AXI/Reg] -force

    # Host-side control map.
    assign_bd_address -offset 0x00010000 -range 0x00001000 \
        -target_address_space [get_bd_addr_spaces s_axi_ctrl] \
        [get_bd_addr_segs axil_jtag_bridge/S_AXI/reg0] -force
    assign_bd_address -offset 0x00000000 -range 0x00010000 \
        -with_name SEG_bootrom_bram_ctrl_Mem0 \
        -target_address_space [get_bd_addr_spaces s_axi_ctrl] \
        [get_bd_addr_segs dut_bootrom_ctrl/S_AXI/Mem0] -force
    assign_bd_address -offset 0x00011000 -range 0x00001000 \
        -target_address_space [get_bd_addr_spaces s_axi_ctrl] \
        [get_bd_addr_segs gpio_reset/S_AXI/Reg] -force
    assign_bd_address -offset 0x00012000 -range 0x00001000 \
        -target_address_space [get_bd_addr_spaces s_axi_ctrl] \
        [get_bd_addr_segs host_uart/S_AXI/Reg] -force

    #=============================================
    # Add ilas
    #=============================================
    if {${::board} == "uvhs2"} {
        set ila [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_ila ila ]
        set_property -dict [list \
            CONFIG.C_MON_TYPE {Mixed} \
            CONFIG.C_NUM_MONITOR_SLOTS {2} \
            CONFIG.C_NUM_OF_PROBES {12} \
            CONFIG.C_PROBE10_WIDTH {3} \
            CONFIG.C_PROBE11_WIDTH {64} \
            CONFIG.C_PROBE2_WIDTH {64} \
            CONFIG.C_PROBE3_WIDTH {50} \
            CONFIG.C_PROBE4_WIDTH {3} \
            CONFIG.C_PROBE5_WIDTH {64} \
            CONFIG.C_PROBE6_WIDTH {3} \
            CONFIG.C_PROBE7_WIDTH {150} \
            CONFIG.C_PROBE8_WIDTH {12} \
            CONFIG.C_PROBE9_WIDTH {21} \
            ] [get_bd_cells ila]
    } else {
        create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila ila
        set_property -dict [list \
            CONFIG.C_MON_TYPE {Mixed} \
            CONFIG.C_NUM_MONITOR_SLOTS {2} \
            CONFIG.C_NUM_OF_PROBES {12} \
            ] [get_bd_cells ila]
    }

    connect_bd_net [get_bd_ports aclk] [get_bd_pins ila/clk]
    connect_bd_net [get_bd_ports aresetn] [get_bd_pins ila/resetn]

    connect_bd_intf_net [get_bd_intf_pins ila/SLOT_0_AXI] [get_bd_intf_pins xs_top/memory]
    connect_bd_intf_net [get_bd_intf_pins ila/SLOT_1_AXI] [get_bd_intf_pins xs_top/peripheral]

    connect_bd_net [get_bd_pins xs_top/riscv_halt] [get_bd_pins ila/probe0]
    connect_bd_net [get_bd_pins xs_top/riscv_critical_error] [get_bd_pins ila/probe1]
    connect_bd_net [get_bd_pins xs_top/trace_cause] [get_bd_pins ila/probe2]
    connect_bd_net [get_bd_pins xs_top/trace_tval] [get_bd_pins ila/probe3]
    connect_bd_net [get_bd_pins xs_top/trace_priv] [get_bd_pins ila/probe4]
    connect_bd_net [get_bd_pins xs_top/trace_mstatus] [get_bd_pins ila/probe5]
    connect_bd_net [get_bd_pins xs_top/trace_valid] [get_bd_pins ila/probe6]
    connect_bd_net [get_bd_pins xs_top/trace_iaddr] [get_bd_pins ila/probe7]
    connect_bd_net [get_bd_pins xs_top/trace_itype] [get_bd_pins ila/probe8]
    connect_bd_net [get_bd_pins xs_top/trace_iretire] [get_bd_pins ila/probe9]
    connect_bd_net [get_bd_pins xs_top/trace_ilastsize] [get_bd_pins ila/probe10]
    connect_bd_net [get_bd_pins intr_concat/dout] [get_bd_pins ila/probe11]

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
