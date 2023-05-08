#========================================================
# Top-level constraint file for Xiangshan on VCU128
# Based on Vivado 2020.2
# Author: Yisong Chang (changyisong@ict.ac.cn)
# Date: 11/01/2023
#========================================================

# PCIe EP GT reference clock
create_clock -period 10.000 -name pcie_ep_ref_clk -waveform {0.000 5.000} [get_ports pcie_ep_gt_ref_clk_clk_p]

set_property PACKAGE_PIN AR15 [get_ports {pcie_ep_gt_ref_clk_clk_p[0]}]

# PL DDR reference clock
create_clock -period 10.000 -name ddr4_mig_sys_clk -waveform {0.000 5.000} [get_ports ddr4_mig_sys_clk_clk_p]

set_property IOSTANDARD DIFF_SSTL12 [get_ports ddr4_mig_sys_clk_clk_n]
set_property IOSTANDARD DIFF_SSTL12 [get_ports ddr4_mig_sys_clk_clk_p]

set_property PACKAGE_PIN BJ51 [get_ports ddr4_mig_sys_clk_clk_n]
set_property PACKAGE_PIN BH51 [get_ports ddr4_mig_sys_clk_clk_p]

# PCIe EP perstn physical location
set_property PACKAGE_PIN BF41 [get_ports pcie_ep_perstn]
set_property IOSTANDARD LVCMOS12 [get_ports pcie_ep_perstn]

# LED
set_property PACKAGE_PIN BH24 [get_ports ddr4_mig_calib_done]
set_property IOSTANDARD LVCMOS18 [get_ports ddr4_mig_calib_done]

set_property PACKAGE_PIN BG24 [get_ports pcie_ep_phy_ready]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_ep_phy_ready]

set_property PACKAGE_PIN BG25 [get_ports pcie_ep_lnk_up]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_ep_lnk_up]

# DDR
set_property BOARD_PIN {ddr4_act_n} [get_ports c0_ddr4_act_n]
set_property BOARD_PIN {ddr4_adr0} [get_ports c0_ddr4_adr[0]]
set_property BOARD_PIN {ddr4_adr1} [get_ports c0_ddr4_adr[1]]
set_property BOARD_PIN {ddr4_adr2} [get_ports c0_ddr4_adr[2]]
set_property BOARD_PIN {ddr4_adr3} [get_ports c0_ddr4_adr[3]]
set_property BOARD_PIN {ddr4_adr4} [get_ports c0_ddr4_adr[4]]
set_property BOARD_PIN {ddr4_adr5} [get_ports c0_ddr4_adr[5]]
set_property BOARD_PIN {ddr4_adr6} [get_ports c0_ddr4_adr[6]]
set_property BOARD_PIN {ddr4_adr7} [get_ports c0_ddr4_adr[7]]
set_property BOARD_PIN {ddr4_adr8} [get_ports c0_ddr4_adr[8]]
set_property BOARD_PIN {ddr4_adr9} [get_ports c0_ddr4_adr[9]]
set_property BOARD_PIN {ddr4_adr10} [get_ports c0_ddr4_adr[10]]
set_property BOARD_PIN {ddr4_adr11} [get_ports c0_ddr4_adr[11]]
set_property BOARD_PIN {ddr4_adr12} [get_ports c0_ddr4_adr[12]]
set_property BOARD_PIN {ddr4_adr13} [get_ports c0_ddr4_adr[13]]
set_property BOARD_PIN {ddr4_adr14} [get_ports c0_ddr4_adr[14]]
set_property BOARD_PIN {ddr4_adr15} [get_ports c0_ddr4_adr[15]]
set_property BOARD_PIN {ddr4_adr16} [get_ports c0_ddr4_adr[16]]
set_property BOARD_PIN {ddr4_ba0} [get_ports c0_ddr4_ba[0]]
set_property BOARD_PIN {ddr4_ba1} [get_ports c0_ddr4_ba[1]]
set_property BOARD_PIN {ddr4_bg} [get_ports c0_ddr4_bg]
set_property BOARD_PIN {ddr4_ck_c} [get_ports c0_ddr4_ck_c]
set_property BOARD_PIN {ddr4_ck_t} [get_ports c0_ddr4_ck_t]
set_property BOARD_PIN {ddr4_cke} [get_ports c0_ddr4_cke]
set_property BOARD_PIN {ddr4_cs_n0} [get_ports c0_ddr4_cs_n[0]]
set_property BOARD_PIN {ddr4_cs_n1} [get_ports c0_ddr4_cs_n[1]]
set_property BOARD_PIN {ddr4_dm_dbi_n0} [get_ports c0_ddr4_dm_n[0]]
set_property BOARD_PIN {ddr4_dm_dbi_n1} [get_ports c0_ddr4_dm_n[1]]
set_property BOARD_PIN {ddr4_dm_dbi_n2} [get_ports c0_ddr4_dm_n[2]]
set_property BOARD_PIN {ddr4_dm_dbi_n3} [get_ports c0_ddr4_dm_n[3]]
set_property BOARD_PIN {ddr4_dm_dbi_n4} [get_ports c0_ddr4_dm_n[4]]
set_property BOARD_PIN {ddr4_dm_dbi_n5} [get_ports c0_ddr4_dm_n[5]]
set_property BOARD_PIN {ddr4_dm_dbi_n6} [get_ports c0_ddr4_dm_n[6]]
set_property BOARD_PIN {ddr4_dm_dbi_n7} [get_ports c0_ddr4_dm_n[7]]
# set_property BOARD_PIN {ddr4_dm_dbi_n0} [get_ports c0_ddr4_dm_dbi_n[0]]
# set_property BOARD_PIN {ddr4_dm_dbi_n1} [get_ports c0_ddr4_dm_dbi_n[1]]
# set_property BOARD_PIN {ddr4_dm_dbi_n2} [get_ports c0_ddr4_dm_dbi_n[2]]
# set_property BOARD_PIN {ddr4_dm_dbi_n3} [get_ports c0_ddr4_dm_dbi_n[3]]
# set_property BOARD_PIN {ddr4_dm_dbi_n4} [get_ports c0_ddr4_dm_dbi_n[4]]
# set_property BOARD_PIN {ddr4_dm_dbi_n5} [get_ports c0_ddr4_dm_dbi_n[5]]
# set_property BOARD_PIN {ddr4_dm_dbi_n6} [get_ports c0_ddr4_dm_dbi_n[6]]
# set_property BOARD_PIN {ddr4_dm_dbi_n7} [get_ports c0_ddr4_dm_dbi_n[7]]
# set_property BOARD_PIN {ddr4_dm_dbi_n8} [get_ports c0_ddr4_dm_dbi_n[8]] # ECC
set_property BOARD_PIN {ddr4_dq0} [get_ports c0_ddr4_dq[0]]
set_property BOARD_PIN {ddr4_dq1} [get_ports c0_ddr4_dq[1]]
set_property BOARD_PIN {ddr4_dq2} [get_ports c0_ddr4_dq[2]]
set_property BOARD_PIN {ddr4_dq3} [get_ports c0_ddr4_dq[3]]
set_property BOARD_PIN {ddr4_dq4} [get_ports c0_ddr4_dq[4]]
set_property BOARD_PIN {ddr4_dq5} [get_ports c0_ddr4_dq[5]]
set_property BOARD_PIN {ddr4_dq6} [get_ports c0_ddr4_dq[6]]
set_property BOARD_PIN {ddr4_dq7} [get_ports c0_ddr4_dq[7]]
set_property BOARD_PIN {ddr4_dq8} [get_ports c0_ddr4_dq[8]]
set_property BOARD_PIN {ddr4_dq9} [get_ports c0_ddr4_dq[9]]
set_property BOARD_PIN {ddr4_dq10} [get_ports c0_ddr4_dq[10]]
set_property BOARD_PIN {ddr4_dq11} [get_ports c0_ddr4_dq[11]]
set_property BOARD_PIN {ddr4_dq12} [get_ports c0_ddr4_dq[12]]
set_property BOARD_PIN {ddr4_dq13} [get_ports c0_ddr4_dq[13]]
set_property BOARD_PIN {ddr4_dq14} [get_ports c0_ddr4_dq[14]]
set_property BOARD_PIN {ddr4_dq15} [get_ports c0_ddr4_dq[15]]
set_property BOARD_PIN {ddr4_dq16} [get_ports c0_ddr4_dq[16]]
set_property BOARD_PIN {ddr4_dq17} [get_ports c0_ddr4_dq[17]]
set_property BOARD_PIN {ddr4_dq18} [get_ports c0_ddr4_dq[18]]
set_property BOARD_PIN {ddr4_dq19} [get_ports c0_ddr4_dq[19]]
set_property BOARD_PIN {ddr4_dq20} [get_ports c0_ddr4_dq[20]]
set_property BOARD_PIN {ddr4_dq21} [get_ports c0_ddr4_dq[21]]
set_property BOARD_PIN {ddr4_dq22} [get_ports c0_ddr4_dq[22]]
set_property BOARD_PIN {ddr4_dq23} [get_ports c0_ddr4_dq[23]]
set_property BOARD_PIN {ddr4_dq24} [get_ports c0_ddr4_dq[24]]
set_property BOARD_PIN {ddr4_dq25} [get_ports c0_ddr4_dq[25]]
set_property BOARD_PIN {ddr4_dq26} [get_ports c0_ddr4_dq[26]]
set_property BOARD_PIN {ddr4_dq27} [get_ports c0_ddr4_dq[27]]
set_property BOARD_PIN {ddr4_dq28} [get_ports c0_ddr4_dq[28]]
set_property BOARD_PIN {ddr4_dq29} [get_ports c0_ddr4_dq[29]]
set_property BOARD_PIN {ddr4_dq30} [get_ports c0_ddr4_dq[30]]
set_property BOARD_PIN {ddr4_dq31} [get_ports c0_ddr4_dq[31]]
set_property BOARD_PIN {ddr4_dq32} [get_ports c0_ddr4_dq[32]]
set_property BOARD_PIN {ddr4_dq33} [get_ports c0_ddr4_dq[33]]
set_property BOARD_PIN {ddr4_dq34} [get_ports c0_ddr4_dq[34]]
set_property BOARD_PIN {ddr4_dq35} [get_ports c0_ddr4_dq[35]]
set_property BOARD_PIN {ddr4_dq36} [get_ports c0_ddr4_dq[36]]
set_property BOARD_PIN {ddr4_dq37} [get_ports c0_ddr4_dq[37]]
set_property BOARD_PIN {ddr4_dq38} [get_ports c0_ddr4_dq[38]]
set_property BOARD_PIN {ddr4_dq39} [get_ports c0_ddr4_dq[39]]
set_property BOARD_PIN {ddr4_dq40} [get_ports c0_ddr4_dq[40]]
set_property BOARD_PIN {ddr4_dq41} [get_ports c0_ddr4_dq[41]]
set_property BOARD_PIN {ddr4_dq42} [get_ports c0_ddr4_dq[42]]
set_property BOARD_PIN {ddr4_dq43} [get_ports c0_ddr4_dq[43]]
set_property BOARD_PIN {ddr4_dq44} [get_ports c0_ddr4_dq[44]]
set_property BOARD_PIN {ddr4_dq45} [get_ports c0_ddr4_dq[45]]
set_property BOARD_PIN {ddr4_dq46} [get_ports c0_ddr4_dq[46]]
set_property BOARD_PIN {ddr4_dq47} [get_ports c0_ddr4_dq[47]]
set_property BOARD_PIN {ddr4_dq48} [get_ports c0_ddr4_dq[48]]
set_property BOARD_PIN {ddr4_dq49} [get_ports c0_ddr4_dq[49]]
set_property BOARD_PIN {ddr4_dq50} [get_ports c0_ddr4_dq[50]]
set_property BOARD_PIN {ddr4_dq51} [get_ports c0_ddr4_dq[51]]
set_property BOARD_PIN {ddr4_dq52} [get_ports c0_ddr4_dq[52]]
set_property BOARD_PIN {ddr4_dq53} [get_ports c0_ddr4_dq[53]]
set_property BOARD_PIN {ddr4_dq54} [get_ports c0_ddr4_dq[54]]
set_property BOARD_PIN {ddr4_dq55} [get_ports c0_ddr4_dq[55]]
set_property BOARD_PIN {ddr4_dq56} [get_ports c0_ddr4_dq[56]]
set_property BOARD_PIN {ddr4_dq57} [get_ports c0_ddr4_dq[57]]
set_property BOARD_PIN {ddr4_dq58} [get_ports c0_ddr4_dq[58]]
set_property BOARD_PIN {ddr4_dq59} [get_ports c0_ddr4_dq[59]]
set_property BOARD_PIN {ddr4_dq60} [get_ports c0_ddr4_dq[60]]
set_property BOARD_PIN {ddr4_dq61} [get_ports c0_ddr4_dq[61]]
set_property BOARD_PIN {ddr4_dq62} [get_ports c0_ddr4_dq[62]]
set_property BOARD_PIN {ddr4_dq63} [get_ports c0_ddr4_dq[63]]
# set_property BOARD_PIN {ddr4_dq64} [get_ports c0_ddr4_dq[64]] # ECC
# set_property BOARD_PIN {ddr4_dq65} [get_ports c0_ddr4_dq[65]] # ECC
# set_property BOARD_PIN {ddr4_dq66} [get_ports c0_ddr4_dq[66]] # ECC
# set_property BOARD_PIN {ddr4_dq67} [get_ports c0_ddr4_dq[67]] # ECC
# set_property BOARD_PIN {ddr4_dq68} [get_ports c0_ddr4_dq[68]] # ECC
# set_property BOARD_PIN {ddr4_dq69} [get_ports c0_ddr4_dq[69]] # ECC
# set_property BOARD_PIN {ddr4_dq70} [get_ports c0_ddr4_dq[70]] # ECC
# set_property BOARD_PIN {ddr4_dq71} [get_ports c0_ddr4_dq[71]] # ECC
set_property BOARD_PIN {ddr4_dqs_c0} [get_ports c0_ddr4_dqs_c[0]]
set_property BOARD_PIN {ddr4_dqs_c1} [get_ports c0_ddr4_dqs_c[1]]
set_property BOARD_PIN {ddr4_dqs_c2} [get_ports c0_ddr4_dqs_c[2]]
set_property BOARD_PIN {ddr4_dqs_c3} [get_ports c0_ddr4_dqs_c[3]]
set_property BOARD_PIN {ddr4_dqs_c4} [get_ports c0_ddr4_dqs_c[4]]
set_property BOARD_PIN {ddr4_dqs_c5} [get_ports c0_ddr4_dqs_c[5]]
set_property BOARD_PIN {ddr4_dqs_c6} [get_ports c0_ddr4_dqs_c[6]]
set_property BOARD_PIN {ddr4_dqs_c7} [get_ports c0_ddr4_dqs_c[7]]
# set_property BOARD_PIN {ddr4_dqs_c8} [get_ports c0_ddr4_dqs_c[8]] # ECC
set_property BOARD_PIN {ddr4_dqs_t0} [get_ports c0_ddr4_dqs_t[0]]
set_property BOARD_PIN {ddr4_dqs_t1} [get_ports c0_ddr4_dqs_t[1]]
set_property BOARD_PIN {ddr4_dqs_t2} [get_ports c0_ddr4_dqs_t[2]]
set_property BOARD_PIN {ddr4_dqs_t3} [get_ports c0_ddr4_dqs_t[3]]
set_property BOARD_PIN {ddr4_dqs_t4} [get_ports c0_ddr4_dqs_t[4]]
set_property BOARD_PIN {ddr4_dqs_t5} [get_ports c0_ddr4_dqs_t[5]]
set_property BOARD_PIN {ddr4_dqs_t6} [get_ports c0_ddr4_dqs_t[6]]
set_property BOARD_PIN {ddr4_dqs_t7} [get_ports c0_ddr4_dqs_t[7]]
# set_property BOARD_PIN {ddr4_dqs_t8} [get_ports c0_ddr4_dqs_t[8]] # ECC
set_property BOARD_PIN {ddr4_odt} [get_ports c0_ddr4_odt]
set_property BOARD_PIN {ddr4_reset_n} [get_ports c0_ddr4_reset_n]
