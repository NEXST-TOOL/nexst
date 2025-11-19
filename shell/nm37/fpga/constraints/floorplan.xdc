# Locating SHELL into SLR0

create_pblock shell_region
resize_pblock shell_region -add SLR0
set_property EXCLUDE_PLACEMENT false [get_pblocks shell_region]
set_property CONTAIN_ROUTING false [get_pblocks shell_region]

add_cells_to_pblock shell_region \
    [get_cells [list \
    xiangshan_i/axi_ic_bootrom \
    xiangshan_i/axi_dwidth_converter_0 \
    xiangshan_i/axi_ic_ddr_mem \
    xiangshan_i/axi_ic_ep_bar_axi_lite \
    xiangshan_i/axi_ic_pcie_rp_dma \
    xiangshan_i/axi_ic_pcie_rp_mmio \
    xiangshan_i/axi_ic_role_io \
    xiangshan_i/axi_mm_base_reg \
    xiangshan_i/bootrom_bram \
    xiangshan_i/bootrom_bram_ctrl \
    xiangshan_i/ddr4_mig \
    xiangshan_i/ddr4_mig_sync_reset \
    xiangshan_i/ep_perst_gen \
    xiangshan_i/host_uart \
    xiangshan_i/pcie_rp_role_sync_reset \
    xiangshan_i/pcie_rp_sync_reset \
    xiangshan_i/role_uart \
    xiangshan_i/slice_xdma_ep_m_axib_araddr \ 
    xiangshan_i/slice_xdma_ep_m_axib_awaddr \ 
    xiangshan_i/xdma_ep \
    xiangshan_i/xdma_rp ]] -clear_locs