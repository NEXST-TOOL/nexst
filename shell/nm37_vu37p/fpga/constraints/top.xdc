#========================================================
# Top-level constraint file for Xiangshan on VCU128
# Based on Vivado 2020.2
# Author: Yisong Chang (changyisong@ict.ac.cn)
# Date: 11/01/2023
#========================================================

# PCIe EP GT reference clock
create_clock -period 10.000 -name pcie_ep_ref_clk -waveform {0.000 5.000} [get_ports pcie_ep_gt_ref_clk_clk_p]

set_property PACKAGE_PIN AR15 [get_ports {pcie_ep_gt_ref_clk_clk_p[0]}]

# PCIe RP GT reference clock
create_clock -period 10.000 -name pcie_rp_ref_clk -waveform {0.000 5.000} [get_ports pcie_rp_gt_ref_clk_clk_p]

set_property PACKAGE_PIN AK42 [get_ports {pcie_rp_gt_ref_clk_clk_p[0]}]

# PL DDR reference clock
create_clock -period 10.000 -name ddr4_mig_sys_clk -waveform {0.000 5.000} [get_ports ddr4_mig_sys_clk_clk_p]

set_property IOSTANDARD DIFF_SSTL12 [get_ports ddr4_mig_sys_clk_clk_n]
set_property IOSTANDARD DIFF_SSTL12 [get_ports ddr4_mig_sys_clk_clk_p]

set_property PACKAGE_PIN BH42 [get_ports ddr4_mig_sys_clk_clk_p]
set_property PACKAGE_PIN BJ42 [get_ports ddr4_mig_sys_clk_clk_n]

# PCIe EP perstn physical location
set_property PACKAGE_PIN BF5 [get_ports pcie_ep_perstn]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_ep_perstn]

# PCIe RP perstn physical location
# NM37 M.2
set_property PACKAGE_PIN J16 [get_ports {pcie_rp_perstn[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {pcie_rp_perstn[0]}]

# PCIe RP GT physical location
set_property LOC GTYE4_CHANNEL_X0Y12 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST}]
set_property LOC GTYE4_CHANNEL_X0Y13 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST}]
set_property LOC GTYE4_CHANNEL_X0Y14 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST}]
set_property LOC GTYE4_CHANNEL_X0Y15 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]

# DDR
set_property PACKAGE_PIN BP44 [get_ports c0_ddr4_act_n]
set_property PACKAGE_PIN BK45 [get_ports {c0_ddr4_adr[0]}]
set_property PACKAGE_PIN BL45 [get_ports {c0_ddr4_adr[1]}]
set_property PACKAGE_PIN BL43 [get_ports {c0_ddr4_adr[2]}]
set_property PACKAGE_PIN BN44 [get_ports {c0_ddr4_adr[3]}]
set_property PACKAGE_PIN BP46 [get_ports {c0_ddr4_adr[4]}]
set_property PACKAGE_PIN BL46 [get_ports {c0_ddr4_adr[5]}]
set_property PACKAGE_PIN BH46 [get_ports {c0_ddr4_adr[6]}]
set_property PACKAGE_PIN BJ43 [get_ports {c0_ddr4_adr[7]}]
set_property PACKAGE_PIN BN46 [get_ports {c0_ddr4_adr[8]}]
set_property PACKAGE_PIN BN45 [get_ports {c0_ddr4_adr[9]}]
set_property PACKAGE_PIN BM42 [get_ports {c0_ddr4_adr[10]}]
set_property PACKAGE_PIN BM45 [get_ports {c0_ddr4_adr[11]}]
set_property PACKAGE_PIN BH44 [get_ports {c0_ddr4_adr[12]}]
set_property PACKAGE_PIN BL42 [get_ports {c0_ddr4_adr[13]}]
set_property PACKAGE_PIN BH41 [get_ports {c0_ddr4_adr[14]}]
set_property PACKAGE_PIN BK43 [get_ports {c0_ddr4_adr[15]}]
set_property PACKAGE_PIN BJ41 [get_ports {c0_ddr4_adr[16]}]
set_property PACKAGE_PIN BK41 [get_ports {c0_ddr4_ba[0]}]
set_property PACKAGE_PIN BG43 [get_ports {c0_ddr4_ba[1]}]
set_property PACKAGE_PIN BK46 [get_ports {c0_ddr4_bg[0]}]
set_property PACKAGE_PIN BJ44 [get_ports {c0_ddr4_bg[1]}]
set_property PACKAGE_PIN BN42 [get_ports {c0_ddr4_ck_t[0]}]
set_property PACKAGE_PIN BP42 [get_ports {c0_ddr4_ck_c[0]}]
set_property PACKAGE_PIN BN47 [get_ports {c0_ddr4_ck_t[1]}]
set_property PACKAGE_PIN BP47 [get_ports {c0_ddr4_ck_c[1]}]
set_property PACKAGE_PIN BM47 [get_ports {c0_ddr4_cke[0]}]
set_property PACKAGE_PIN BJ46 [get_ports {c0_ddr4_cke[1]}]
set_property PACKAGE_PIN BG42 [get_ports {c0_ddr4_cs_n[0]}]
set_property PACKAGE_PIN BE41 [get_ports {c0_ddr4_cs_n[1]}]
set_property PACKAGE_PIN BG48 [get_ports {c0_ddr4_dm_n[0]}]
set_property PACKAGE_PIN BJ52 [get_ports {c0_ddr4_dm_n[1]}]
set_property PACKAGE_PIN BK48 [get_ports {c0_ddr4_dm_n[2]}]
set_property PACKAGE_PIN BP48 [get_ports {c0_ddr4_dm_n[3]}]
set_property PACKAGE_PIN BH32 [get_ports {c0_ddr4_dm_n[4]}]
set_property PACKAGE_PIN BM34 [get_ports {c0_ddr4_dm_n[5]}]
set_property PACKAGE_PIN BM28 [get_ports {c0_ddr4_dm_n[6]}]
set_property PACKAGE_PIN BG29 [get_ports {c0_ddr4_dm_n[7]}]
set_property PACKAGE_PIN BE49 [get_ports {c0_ddr4_dq[0]}]
set_property PACKAGE_PIN BE51 [get_ports {c0_ddr4_dq[1]}]
set_property PACKAGE_PIN BF50 [get_ports {c0_ddr4_dq[2]}]
set_property PACKAGE_PIN BF52 [get_ports {c0_ddr4_dq[3]}]
set_property PACKAGE_PIN BE50 [get_ports {c0_ddr4_dq[4]}]
set_property PACKAGE_PIN BD51 [get_ports {c0_ddr4_dq[5]}]
set_property PACKAGE_PIN BG50 [get_ports {c0_ddr4_dq[6]}]
set_property PACKAGE_PIN BF51 [get_ports {c0_ddr4_dq[7]}]
set_property PACKAGE_PIN BE54 [get_ports {c0_ddr4_dq[8]}]
set_property PACKAGE_PIN BG52 [get_ports {c0_ddr4_dq[9]}]
set_property PACKAGE_PIN BG54 [get_ports {c0_ddr4_dq[10]}]
set_property PACKAGE_PIN BK54 [get_ports {c0_ddr4_dq[11]}]
set_property PACKAGE_PIN BE53 [get_ports {c0_ddr4_dq[12]}]
set_property PACKAGE_PIN BG53 [get_ports {c0_ddr4_dq[13]}]
set_property PACKAGE_PIN BK53 [get_ports {c0_ddr4_dq[14]}]
set_property PACKAGE_PIN BH52 [get_ports {c0_ddr4_dq[15]}]
set_property PACKAGE_PIN BH51 [get_ports {c0_ddr4_dq[16]}]
set_property PACKAGE_PIN BJ51 [get_ports {c0_ddr4_dq[17]}]
set_property PACKAGE_PIN BH50 [get_ports {c0_ddr4_dq[18]}]
set_property PACKAGE_PIN BJ49 [get_ports {c0_ddr4_dq[19]}]
set_property PACKAGE_PIN BK50 [get_ports {c0_ddr4_dq[20]}]
set_property PACKAGE_PIN BK51 [get_ports {c0_ddr4_dq[21]}]
set_property PACKAGE_PIN BH49 [get_ports {c0_ddr4_dq[22]}]
set_property PACKAGE_PIN BJ48 [get_ports {c0_ddr4_dq[23]}]
set_property PACKAGE_PIN BL53 [get_ports {c0_ddr4_dq[24]}]
set_property PACKAGE_PIN BL52 [get_ports {c0_ddr4_dq[25]}]
set_property PACKAGE_PIN BN50 [get_ports {c0_ddr4_dq[26]}]
set_property PACKAGE_PIN BM48 [get_ports {c0_ddr4_dq[27]}]
set_property PACKAGE_PIN BL51 [get_ports {c0_ddr4_dq[28]}]
set_property PACKAGE_PIN BM52 [get_ports {c0_ddr4_dq[29]}]
set_property PACKAGE_PIN BN51 [get_ports {c0_ddr4_dq[30]}]
set_property PACKAGE_PIN BN49 [get_ports {c0_ddr4_dq[31]}]
set_property PACKAGE_PIN BF35 [get_ports {c0_ddr4_dq[32]}]
set_property PACKAGE_PIN BH35 [get_ports {c0_ddr4_dq[33]}]
set_property PACKAGE_PIN BJ33 [get_ports {c0_ddr4_dq[34]}]
set_property PACKAGE_PIN BG35 [get_ports {c0_ddr4_dq[35]}]
set_property PACKAGE_PIN BF36 [get_ports {c0_ddr4_dq[36]}]
set_property PACKAGE_PIN BH34 [get_ports {c0_ddr4_dq[37]}]
set_property PACKAGE_PIN BJ34 [get_ports {c0_ddr4_dq[38]}]
set_property PACKAGE_PIN BG34 [get_ports {c0_ddr4_dq[39]}]
set_property PACKAGE_PIN BN34 [get_ports {c0_ddr4_dq[40]}]
set_property PACKAGE_PIN BL33 [get_ports {c0_ddr4_dq[41]}]
set_property PACKAGE_PIN BL31 [get_ports {c0_ddr4_dq[42]}]
set_property PACKAGE_PIN BK31 [get_ports {c0_ddr4_dq[43]}]
set_property PACKAGE_PIN BP34 [get_ports {c0_ddr4_dq[44]}]
set_property PACKAGE_PIN BM33 [get_ports {c0_ddr4_dq[45]}]
set_property PACKAGE_PIN BL32 [get_ports {c0_ddr4_dq[46]}]
set_property PACKAGE_PIN BK33 [get_ports {c0_ddr4_dq[47]}]
set_property PACKAGE_PIN BP32 [get_ports {c0_ddr4_dq[48]}]
set_property PACKAGE_PIN BN31 [get_ports {c0_ddr4_dq[49]}]
set_property PACKAGE_PIN BP28 [get_ports {c0_ddr4_dq[50]}]
set_property PACKAGE_PIN BL30 [get_ports {c0_ddr4_dq[51]}]
set_property PACKAGE_PIN BP31 [get_ports {c0_ddr4_dq[52]}]
set_property PACKAGE_PIN BN32 [get_ports {c0_ddr4_dq[53]}]
set_property PACKAGE_PIN BP29 [get_ports {c0_ddr4_dq[54]}]
set_property PACKAGE_PIN BM30 [get_ports {c0_ddr4_dq[55]}]
set_property PACKAGE_PIN BH31 [get_ports {c0_ddr4_dq[56]}]
set_property PACKAGE_PIN BH29 [get_ports {c0_ddr4_dq[57]}]
set_property PACKAGE_PIN BF31 [get_ports {c0_ddr4_dq[58]}]
set_property PACKAGE_PIN BF32 [get_ports {c0_ddr4_dq[59]}]
set_property PACKAGE_PIN BH30 [get_ports {c0_ddr4_dq[60]}]
set_property PACKAGE_PIN BJ31 [get_ports {c0_ddr4_dq[61]}]
set_property PACKAGE_PIN BG32 [get_ports {c0_ddr4_dq[62]}]
set_property PACKAGE_PIN BF33 [get_ports {c0_ddr4_dq[63]}]
set_property PACKAGE_PIN BF47 [get_ports {c0_ddr4_dqs_t[0]}]
set_property PACKAGE_PIN BF48 [get_ports {c0_ddr4_dqs_c[0]}]
set_property PACKAGE_PIN BH54 [get_ports {c0_ddr4_dqs_t[1]}]
set_property PACKAGE_PIN BJ54 [get_ports {c0_ddr4_dqs_c[1]}]
set_property PACKAGE_PIN BH47 [get_ports {c0_ddr4_dqs_t[2]}]
set_property PACKAGE_PIN BJ47 [get_ports {c0_ddr4_dqs_c[2]}]
set_property PACKAGE_PIN BM49 [get_ports {c0_ddr4_dqs_t[3]}]
set_property PACKAGE_PIN BM50 [get_ports {c0_ddr4_dqs_c[3]}]
set_property PACKAGE_PIN BK34 [get_ports {c0_ddr4_dqs_t[4]}]
set_property PACKAGE_PIN BK35 [get_ports {c0_ddr4_dqs_c[4]}]
set_property PACKAGE_PIN BL35 [get_ports {c0_ddr4_dqs_t[5]}]
set_property PACKAGE_PIN BM35 [get_ports {c0_ddr4_dqs_c[5]}]
set_property PACKAGE_PIN BN29 [get_ports {c0_ddr4_dqs_t[6]}]
set_property PACKAGE_PIN BN30 [get_ports {c0_ddr4_dqs_c[6]}]
set_property PACKAGE_PIN BJ29 [get_ports {c0_ddr4_dqs_t[7]}]
set_property PACKAGE_PIN BK30 [get_ports {c0_ddr4_dqs_c[7]}]
set_property PACKAGE_PIN BF41 [get_ports {c0_ddr4_odt[0]}]
set_property PACKAGE_PIN BH45 [get_ports {c0_ddr4_odt[1]}]
set_property PACKAGE_PIN BL47 [get_ports c0_ddr4_reset_n]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list xiangshan_i/xdma_rp/inst/pcie4c_ip_i/inst/xiangshan_xdma_rp_0_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/CLK_PCLK2_GT]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 1 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list xiangshan_i/xdma_rp/axi_ctl_aresetn]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list xiangshan_i/xdma_rp/inst/pcie4c_ip_i/inst/xiangshan_xdma_rp_0_pcie4c_ip_gt_top_i/diablo_gt.diablo_gt_phy_wrapper/phy_clk_i/CLK_CORECLK]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 1 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list xiangshan_i/xdma_rp/inst/pcie4c_ip_i/user_lnk_up]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
