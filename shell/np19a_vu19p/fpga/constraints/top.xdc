#========================================================
# Top-level constraint file for Xiangshan on VCU128
# Based on Vivado 2020.2
# Author: Yisong Chang (changyisong@ict.ac.cn)
# Date: 11/01/2023
#========================================================

# PCIe EP GT reference clock
create_clock -period 10.000 -name pcie_ep_ref_clk -waveform {0.000 5.000} [get_ports pcie_ep_gt_ref_clk_clk_p]

set_property PACKAGE_PIN BE11 [get_ports {pcie_ep_gt_ref_clk_clk_p[0]}]

# PCIe RP GT reference clock
create_clock -period 10.000 -name pcie_rp_ref_clk -waveform {0.000 5.000} [get_ports pcie_rp_gt_ref_clk_clk_p]

set_property PACKAGE_PIN AU11 [get_ports {pcie_rp_gt_ref_clk_clk_p[0]}]

# PCIe RP_ETH GT reference clock
create_clock -period 10.000 -name pcie_rp_eth_ref_clk -waveform {0.000 5.000} [get_ports pcie_rp_eth_gt_ref_clk_clk_p]

set_property PACKAGE_PIN BR11 [get_ports {pcie_rp_eth_gt_ref_clk_clk_p[0]}]



# PL DDR reference clock
create_clock -period 10.000 -name ddr4_mig_sys_clk -waveform {0.000 5.000} [get_ports ddr4_mig_sys_clk_clk_p]

set_property IOSTANDARD DIFF_SSTL12 [get_ports ddr4_mig_sys_clk_clk_n]
set_property IOSTANDARD DIFF_SSTL12 [get_ports ddr4_mig_sys_clk_clk_p]

set_property PACKAGE_PIN AL61 [get_ports ddr4_mig_sys_clk_clk_n]
set_property PACKAGE_PIN AL60 [get_ports ddr4_mig_sys_clk_clk_p]

# DUT's RTC reference clock
create_clock -period 100.000 -name dut_rtc_ref_clk -waveform {0.000 50.000} [get_ports dut_rtc_ref_clk_clk_p]

set_property IOSTANDARD DIFF_SSTL18_I [get_ports {dut_rtc_ref_clk_clk_n[0]}]
set_property IOSTANDARD DIFF_SSTL18_I [get_ports {dut_rtc_ref_clk_clk_p[0]}]

set_property PACKAGE_PIN D31 [get_ports {dut_rtc_ref_clk_clk_n[0]}]
set_property PACKAGE_PIN D32 [get_ports {dut_rtc_ref_clk_clk_p[0]}]



# PCIe EP perstn physical location
set_property PACKAGE_PIN BG16 [get_ports pcie_ep_perstn]
set_property IOSTANDARD LVCMOS12 [get_ports pcie_ep_perstn]

# PCIe RP perstn physical location
set_property PACKAGE_PIN AU17 [get_ports pcie_rp_perstn]
set_property IOSTANDARD LVCMOS33 [get_ports pcie_rp_perstn]

# PCIe RP ETH perstn physical location
set_property PACKAGE_PIN BB17 [get_ports pcie_rp_eth_perstn]
set_property IOSTANDARD LVCMOS33 [get_ports pcie_rp_eth_perstn]


# LED
set_property PACKAGE_PIN AA17 [get_ports ddr4_mig_calib_done]
set_property IOSTANDARD LVCMOS18 [get_ports ddr4_mig_calib_done]

set_property PACKAGE_PIN AA16 [get_ports pcie_ep_phy_ready]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_ep_phy_ready]

set_property PACKAGE_PIN AA15 [get_ports pcie_ep_lnk_up]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_ep_lnk_up]

# DDR
set_property PACKAGE_PIN AR49 [ get_ports "c0_ddr4_dq[0]" ]
set_property PACKAGE_PIN AP47 [ get_ports "c0_ddr4_dq[1]" ]
set_property PACKAGE_PIN AV51 [ get_ports "c0_ddr4_dq[2]" ]
set_property PACKAGE_PIN AV49 [ get_ports "c0_ddr4_dq[3]" ]
set_property PACKAGE_PIN AR50 [ get_ports "c0_ddr4_dq[4]" ]
set_property PACKAGE_PIN AP48 [ get_ports "c0_ddr4_dq[5]" ]
set_property PACKAGE_PIN AV50 [ get_ports "c0_ddr4_dq[6]" ]
set_property PACKAGE_PIN AU49 [ get_ports "c0_ddr4_dq[7]" ]
set_property PACKAGE_PIN AT44 [ get_ports "c0_ddr4_dq[8]" ]
set_property PACKAGE_PIN AV46 [ get_ports "c0_ddr4_dq[9]" ]
set_property PACKAGE_PIN AP45 [ get_ports "c0_ddr4_dq[10]" ]
set_property PACKAGE_PIN AU46 [ get_ports "c0_ddr4_dq[11]" ]
set_property PACKAGE_PIN AT45 [ get_ports "c0_ddr4_dq[12]" ]
set_property PACKAGE_PIN AV45 [ get_ports "c0_ddr4_dq[13]" ]
set_property PACKAGE_PIN AU47 [ get_ports "c0_ddr4_dq[14]" ]
set_property PACKAGE_PIN AP46 [ get_ports "c0_ddr4_dq[15]" ]
set_property PACKAGE_PIN AR54 [ get_ports "c0_ddr4_dq[16]" ]
set_property PACKAGE_PIN AR55 [ get_ports "c0_ddr4_dq[17]" ]
set_property PACKAGE_PIN AU57 [ get_ports "c0_ddr4_dq[18]" ]
set_property PACKAGE_PIN AT55 [ get_ports "c0_ddr4_dq[19]" ]
set_property PACKAGE_PIN AT54 [ get_ports "c0_ddr4_dq[20]" ]
set_property PACKAGE_PIN AP55 [ get_ports "c0_ddr4_dq[21]" ]
set_property PACKAGE_PIN AP56 [ get_ports "c0_ddr4_dq[22]" ]
set_property PACKAGE_PIN AU56 [ get_ports "c0_ddr4_dq[23]" ]
set_property PACKAGE_PIN AR52 [ get_ports "c0_ddr4_dq[24]" ]
set_property PACKAGE_PIN AT52 [ get_ports "c0_ddr4_dq[25]" ]
set_property PACKAGE_PIN AP53 [ get_ports "c0_ddr4_dq[26]" ]
set_property PACKAGE_PIN AU52 [ get_ports "c0_ddr4_dq[27]" ]
set_property PACKAGE_PIN AP52 [ get_ports "c0_ddr4_dq[28]" ]
set_property PACKAGE_PIN AT51 [ get_ports "c0_ddr4_dq[29]" ]
set_property PACKAGE_PIN AR53 [ get_ports "c0_ddr4_dq[30]" ]
set_property PACKAGE_PIN AU51 [ get_ports "c0_ddr4_dq[31]" ]
set_property PACKAGE_PIN BB56 [ get_ports "c0_ddr4_dq[32]" ]
set_property PACKAGE_PIN AY57 [ get_ports "c0_ddr4_dq[33]" ]
set_property PACKAGE_PIN AW58 [ get_ports "c0_ddr4_dq[34]" ]
set_property PACKAGE_PIN BC55 [ get_ports "c0_ddr4_dq[35]" ]
set_property PACKAGE_PIN BC56 [ get_ports "c0_ddr4_dq[36]" ]
set_property PACKAGE_PIN AW57 [ get_ports "c0_ddr4_dq[37]" ]
set_property PACKAGE_PIN BA57 [ get_ports "c0_ddr4_dq[38]" ]
set_property PACKAGE_PIN BB57 [ get_ports "c0_ddr4_dq[39]" ]
set_property PACKAGE_PIN AY53 [ get_ports "c0_ddr4_dq[40]" ]
set_property PACKAGE_PIN AW53 [ get_ports "c0_ddr4_dq[41]" ]
set_property PACKAGE_PIN BA54 [ get_ports "c0_ddr4_dq[42]" ]
set_property PACKAGE_PIN BC54 [ get_ports "c0_ddr4_dq[43]" ]
set_property PACKAGE_PIN AY52 [ get_ports "c0_ddr4_dq[44]" ]
set_property PACKAGE_PIN AW52 [ get_ports "c0_ddr4_dq[45]" ]
set_property PACKAGE_PIN AY54 [ get_ports "c0_ddr4_dq[46]" ]
set_property PACKAGE_PIN BB54 [ get_ports "c0_ddr4_dq[47]" ]
set_property PACKAGE_PIN BA51 [ get_ports "c0_ddr4_dq[48]" ]
set_property PACKAGE_PIN BB51 [ get_ports "c0_ddr4_dq[49]" ]
set_property PACKAGE_PIN BC48 [ get_ports "c0_ddr4_dq[50]" ]
set_property PACKAGE_PIN BA49 [ get_ports "c0_ddr4_dq[51]" ]
set_property PACKAGE_PIN BA50 [ get_ports "c0_ddr4_dq[52]" ]
set_property PACKAGE_PIN AY50 [ get_ports "c0_ddr4_dq[53]" ]
set_property PACKAGE_PIN BB49 [ get_ports "c0_ddr4_dq[54]" ]
set_property PACKAGE_PIN BC49 [ get_ports "c0_ddr4_dq[55]" ]
set_property PACKAGE_PIN AW48 [ get_ports "c0_ddr4_dq[56]" ]
set_property PACKAGE_PIN AY48 [ get_ports "c0_ddr4_dq[57]" ]
set_property PACKAGE_PIN BB46 [ get_ports "c0_ddr4_dq[58]" ]
set_property PACKAGE_PIN AY45 [ get_ports "c0_ddr4_dq[59]" ]
set_property PACKAGE_PIN AW46 [ get_ports "c0_ddr4_dq[60]" ]
set_property PACKAGE_PIN AW47 [ get_ports "c0_ddr4_dq[61]" ]
set_property PACKAGE_PIN AW45 [ get_ports "c0_ddr4_dq[62]" ]
set_property PACKAGE_PIN BA46 [ get_ports "c0_ddr4_dq[63]" ]


set_property PACKAGE_PIN AT49 [ get_ports "c0_ddr4_dm_n[0]" ]
set_property PACKAGE_PIN AR47 [ get_ports "c0_ddr4_dm_n[1]" ]
set_property PACKAGE_PIN AV54 [ get_ports "c0_ddr4_dm_n[2]" ]
set_property PACKAGE_PIN AU53 [ get_ports "c0_ddr4_dm_n[3]" ]
set_property PACKAGE_PIN BA55 [ get_ports "c0_ddr4_dm_n[4]" ]
set_property PACKAGE_PIN BA52 [ get_ports "c0_ddr4_dm_n[5]" ]
set_property PACKAGE_PIN AW50 [ get_ports "c0_ddr4_dm_n[6]" ]
set_property PACKAGE_PIN BB47 [ get_ports "c0_ddr4_dm_n[7]" ]


set_property PACKAGE_PIN AU48 [ get_ports "c0_ddr4_dqs_t[0]" ]
set_property PACKAGE_PIN AV48 [ get_ports "c0_ddr4_dqs_c[0]" ]
set_property PACKAGE_PIN AR44 [ get_ports "c0_ddr4_dqs_t[1]" ]
set_property PACKAGE_PIN AR45 [ get_ports "c0_ddr4_dqs_c[1]" ]
set_property PACKAGE_PIN AT56 [ get_ports "c0_ddr4_dqs_t[2]" ]
set_property PACKAGE_PIN AT57 [ get_ports "c0_ddr4_dqs_c[2]" ]
set_property PACKAGE_PIN AP50 [ get_ports "c0_ddr4_dqs_t[3]" ]
set_property PACKAGE_PIN AP51 [ get_ports "c0_ddr4_dqs_c[3]" ]
set_property PACKAGE_PIN AV56 [ get_ports "c0_ddr4_dqs_t[4]" ]
set_property PACKAGE_PIN AW56 [ get_ports "c0_ddr4_dqs_c[4]" ]
set_property PACKAGE_PIN BB53 [ get_ports "c0_ddr4_dqs_t[5]" ]
set_property PACKAGE_PIN BC53 [ get_ports "c0_ddr4_dqs_c[5]" ]
set_property PACKAGE_PIN BC50 [ get_ports "c0_ddr4_dqs_t[6]" ]
set_property PACKAGE_PIN BC51 [ get_ports "c0_ddr4_dqs_c[6]" ]
set_property PACKAGE_PIN AY47 [ get_ports "c0_ddr4_dqs_t[7]" ]
set_property PACKAGE_PIN BA47 [ get_ports "c0_ddr4_dqs_c[7]" ]


set_property PACKAGE_PIN AN58 [ get_ports "c0_ddr4_adr[0]" ]
set_property PACKAGE_PIN AL57 [ get_ports "c0_ddr4_adr[1]" ]
set_property PACKAGE_PIN AL59 [ get_ports "c0_ddr4_adr[2]" ]
set_property PACKAGE_PIN AJ61 [ get_ports "c0_ddr4_adr[3]" ]
set_property PACKAGE_PIN AK60 [ get_ports "c0_ddr4_adr[4]" ]
set_property PACKAGE_PIN AJ62 [ get_ports "c0_ddr4_adr[5]" ]
set_property PACKAGE_PIN AH63 [ get_ports "c0_ddr4_adr[6]" ]
set_property PACKAGE_PIN AM63 [ get_ports "c0_ddr4_adr[7]" ]
set_property PACKAGE_PIN AH61 [ get_ports "c0_ddr4_adr[8]" ]
set_property PACKAGE_PIN AJ60 [ get_ports "c0_ddr4_adr[9]" ]
set_property PACKAGE_PIN AP58 [ get_ports "c0_ddr4_adr[10]" ]
set_property PACKAGE_PIN AL62 [ get_ports "c0_ddr4_adr[11]" ]
set_property PACKAGE_PIN AK59 [ get_ports "c0_ddr4_adr[12]" ]
set_property PACKAGE_PIN AV59 [ get_ports "c0_ddr4_adr[13]" ]
set_property PACKAGE_PIN AU63 [ get_ports "c0_ddr4_adr[14]" ]
set_property PACKAGE_PIN AU61 [ get_ports "c0_ddr4_adr[15]" ]
set_property PACKAGE_PIN AT59 [ get_ports "c0_ddr4_adr[16]" ]

set_property PACKAGE_PIN AM59 [ get_ports "c0_ddr4_ck_t[0]" ]
set_property PACKAGE_PIN AN59 [ get_ports "c0_ddr4_ck_c[0]" ]
set_property PACKAGE_PIN AR60 [ get_ports "c0_ddr4_ck_t[1]" ]
set_property PACKAGE_PIN AT60 [ get_ports "c0_ddr4_ck_c[1]" ]

set_property PACKAGE_PIN AR58 [ get_ports "c0_ddr4_cs_n[0]" ]
set_property PACKAGE_PIN AU59 [ get_ports "c0_ddr4_cs_n[1]" ]
set_property PACKAGE_PIN AP61 [ get_ports "c0_ddr4_ba[0]" ]
set_property PACKAGE_PIN AR59 [ get_ports "c0_ddr4_ba[1]" ]
set_property PACKAGE_PIN AH60 [ get_ports "c0_ddr4_bg[0]" ]
set_property PACKAGE_PIN AJ58 [ get_ports "c0_ddr4_bg[1]" ]
set_property PACKAGE_PIN AT61 [ get_ports "c0_ddr4_odt[0]" ]
set_property PACKAGE_PIN AU58 [ get_ports "c0_ddr4_odt[1]" ]
set_property PACKAGE_PIN AK58 [ get_ports "c0_ddr4_cke[0]" ]
set_property PACKAGE_PIN AJ63 [ get_ports "c0_ddr4_cke[1]" ]
set_property PACKAGE_PIN AK62 [ get_ports "c0_ddr4_act_n" ]
set_property PACKAGE_PIN AK57 [ get_ports "c0_ddr4_reset_n" ]



