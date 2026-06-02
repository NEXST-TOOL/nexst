#========================================================
# Top-level constraint file for Xiangshan on VCU128
# Based on Vivado 2020.2
# Author: Yisong Chang (changyisong@ict.ac.cn)
# Date: 11/01/2023
#========================================================

# PCIe EP GT reference clock
create_clock -period 10.000 -name pcie_ep_ref_clk -waveform {0.000 5.000} [get_ports pcie_ep_gt_ref_clk_clk_p]
create_clock -period 10.000 -name pcie_rp_j6_ref_clk -waveform {0.000 5.000} [get_ports pcie_rp_j6_gt_ref_clk_clk_p]
create_clock -period 10.000 -name pcie_rp_j9_ref_clk -waveform {0.000 5.000} [get_ports pcie_rp_j9_gt_ref_clk_clk_p]

set_property PACKAGE_PIN AR11 [get_ports {pcie_ep_gt_ref_clk_clk_p[0]}]


set_property PACKAGE_PIN BR11 [get_ports {pcie_rp_j6_gt_ref_clk_clk_p[0]}]

set_property PACKAGE_PIN AU11 [get_ports {pcie_rp_j9_gt_ref_clk_clk_p[0]}]


# PCIe RP GT reference clock
#create_clock -period 10.000 -name pcie_rp_j9_ref_clk -waveform {0.000 5.000} [get_ports pcie_rp_j9_gt_ref_clk_clk_p]

#set_property PACKAGE_PIN AA17 [get_ports {pcie_rp_j9_gt_ref_clk_clk_p[0]}]
#set_property PACKAGE_PIN AA17 [get_ports {sys_clk_0}]


#set_property PACKAGE_PIN AA16 [get_ports {pcie_rp_j9_gt_ref_clk_clk_n[0]}]
#set_property PACKAGE_PIN AA16 [get_ports {sys_clk_gt_0}]

# PCIe RP GT reference clock
#create_clock -period 10.000 -name pcie_rp_j6_ref_clk -waveform {0.000 5.000} [get_ports pcie_rp_j6_gt_ref_clk_clk_p]

#set_property PACKAGE_PIN AA15 [get_ports {pcie_rp_j6_gt_ref_clk_clk_p[0]}]
#set_property PACKAGE_PIN AA14 [get_ports {pcie_rp_j6_gt_ref_clk_clk_n[0]}]

#set_property PACKAGE_PIN AA15 [get_ports {sys_clk_1}]
#set_property PACKAGE_PIN AA14 [get_ports {sys_clk_gt_1}]

# PL DDR reference clock
create_clock -period 12.500 -name ddr4_mig_sys_clk -waveform {0.000 6.250} [get_ports ddr4_mig_sys_clk_clk_p]




set_property IOSTANDARD LVDS [get_ports ddr4_mig_sys_clk_clk_n]
set_property IOSTANDARD LVDS [get_ports ddr4_mig_sys_clk_clk_p]

set_property PACKAGE_PIN Y53 [get_ports ddr4_mig_sys_clk_clk_n]
set_property PACKAGE_PIN Y52 [get_ports ddr4_mig_sys_clk_clk_p]



# DUT's RTC reference clock
#create_clock -period 100.000 -name dut_rtc_ref_clk -waveform {0.000 50.000} [get_ports dut_rtc_ref_clk_clk_p]

#set_property IOSTANDARD DIFF_SSTL18_I [get_ports {dut_rtc_ref_clk_clk_n[0]}]
#set_property IOSTANDARD DIFF_SSTL18_I [get_ports {dut_rtc_ref_clk_clk_p[0]}]

#set_property PACKAGE_PIN D31 [get_ports {dut_rtc_ref_clk_clk_n[0]}]
#set_property PACKAGE_PIN D32 [get_ports {dut_rtc_ref_clk_clk_p[0]}]



# PCIe EP perstn physical location
set_property PACKAGE_PIN B26 [get_ports pcie_ep_perstn]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_ep_perstn]

# PCIe RP perstn physical location
set_property PACKAGE_PIN C24 [get_ports pcie_rp_j9_perstn]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_rp_j9_perstn]

# PCIe RP ETH perstn physical location
set_property PACKAGE_PIN A21 [get_ports pcie_rp_j6_perstn]
set_property IOSTANDARD LVCMOS18 [get_ports pcie_rp_j6_perstn]

# LED
#set_property PACKAGE_PIN AA17 [get_ports ddr4_mig_calib_done]
#set_property IOSTANDARD LVCMOS18 [get_ports ddr4_mig_calib_done]

#set_property PACKAGE_PIN AA16 [get_ports pcie_ep_phy_ready]
#set_property IOSTANDARD LVCMOS18 [get_ports pcie_ep_phy_ready]

#set_property PACKAGE_PIN AA15 [get_ports pcie_ep_lnk_up]
#set_property IOSTANDARD LVCMOS18 [get_ports pcie_ep_lnk_up]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets xiangshan_i/util_ds_buf_1/U0/IBUF_OUT[0]]




set_property PACKAGE_PIN {} [get_ports {pcie_ep_rxp[7]}]
set_property PACKAGE_PIN {} [get_ports {pcie_ep_rxp[6]}]
set_property PACKAGE_PIN {} [get_ports {pcie_ep_rxp[5]}]
set_property PACKAGE_PIN {} [get_ports {pcie_ep_rxp[4]}]
set_property PACKAGE_PIN {} [get_ports {pcie_ep_rxp[3]}]
set_property PACKAGE_PIN {} [get_ports {pcie_ep_rxp[2]}]
set_property PACKAGE_PIN {} [get_ports {pcie_ep_rxp[1]}]
set_property PACKAGE_PIN {} [get_ports {pcie_ep_rxp[0]}]

set_property PACKAGE_PIN AM4  [get_ports {pcie_ep_rxp[0]}]
set_property PACKAGE_PIN AL2  [get_ports {pcie_ep_rxp[1]}]
set_property PACKAGE_PIN AK4  [get_ports {pcie_ep_rxp[2]}]
set_property PACKAGE_PIN AJ2  [get_ports {pcie_ep_rxp[3]}]
set_property PACKAGE_PIN AH4  [get_ports {pcie_ep_rxp[4]}]
set_property PACKAGE_PIN AG2  [get_ports {pcie_ep_rxp[5]}]
set_property PACKAGE_PIN AF4  [get_ports {pcie_ep_rxp[6]}]
set_property PACKAGE_PIN AE2  [get_ports {pcie_ep_rxp[7]}]





#ddr
set_property PACKAGE_PIN M58 [ get_ports "c0_ddr4_dq[36]" ]
set_property PACKAGE_PIN M57 [ get_ports "c0_ddr4_dq[37]" ]
set_property PACKAGE_PIN N55 [ get_ports "c0_ddr4_dq[34]" ]
set_property PACKAGE_PIN P57 [ get_ports "c0_ddr4_dm_n[4]" ]
set_property PACKAGE_PIN K57 [ get_ports "c0_ddr4_dq[35]" ]
set_property PACKAGE_PIN L57 [ get_ports "c0_ddr4_dq[32]" ]
set_property PACKAGE_PIN N58 [ get_ports "c0_ddr4_dq[33]" ]
set_property PACKAGE_PIN M56 [ get_ports "c0_ddr4_dqs_t[4]" ]
set_property PACKAGE_PIN N56 [ get_ports "c0_ddr4_dq[38]" ]
set_property PACKAGE_PIN L56 [ get_ports "c0_ddr4_dqs_c[4]" ]
set_property PACKAGE_PIN K58 [ get_ports "c0_ddr4_dq[39]" ]
set_property PACKAGE_PIN AE59 [ get_ports "c0_ddr4_dm_n[3]" ]
set_property PACKAGE_PIN AC58 [ get_ports "c0_ddr4_dq[26]" ]
set_property PACKAGE_PIN AD63 [ get_ports "c0_ddr4_dq[28]" ]
set_property PACKAGE_PIN AC61 [ get_ports "c0_ddr4_dq[29]" ]
set_property PACKAGE_PIN V59 [ get_ports "c0_ddr4_dq[14]" ]
set_property PACKAGE_PIN AC63 [ get_ports "c0_ddr4_dqs_t[3]" ]
set_property PACKAGE_PIN AD62 [ get_ports "c0_ddr4_dq[24]" ]
set_property PACKAGE_PIN AD61 [ get_ports "c0_ddr4_dq[27]" ]
set_property PACKAGE_PIN U63 [ get_ports "c0_ddr4_dq[15]" ]
set_property PACKAGE_PIN V60 [ get_ports "c0_ddr4_dqs_t[1]" ]
set_property PACKAGE_PIN AB63 [ get_ports "c0_ddr4_dqs_c[3]" ]
set_property PACKAGE_PIN AC60 [ get_ports "c0_ddr4_dq[25]" ]
set_property PACKAGE_PIN AC59 [ get_ports "c0_ddr4_dq[30]" ]
set_property PACKAGE_PIN W63 [ get_ports "c0_ddr4_dq[12]" ]
set_property PACKAGE_PIN V61 [ get_ports "c0_ddr4_dqs_c[1]" ]
set_property PACKAGE_PIN AF62 [ get_ports "c0_ddr4_dq[22]" ]
set_property PACKAGE_PIN AF61 [ get_ports "c0_ddr4_dq[20]" ]
set_property PACKAGE_PIN AD60 [ get_ports "c0_ddr4_dq[31]" ]
set_property PACKAGE_PIN V63 [ get_ports "c0_ddr4_dq[13]" ]
set_property PACKAGE_PIN U62 [ get_ports "c0_ddr4_dq[10]" ]
set_property PACKAGE_PIN W62 [ get_ports "c0_ddr4_dq[8]" ]
set_property PACKAGE_PIN AG59 [ get_ports "c0_ddr4_dq[23]" ]
set_property PACKAGE_PIN AF59 [ get_ports "c0_ddr4_dq[21]" ]
set_property PACKAGE_PIN AE62 [ get_ports "c0_ddr4_dq[18]" ]
set_property PACKAGE_PIN AH58 [ get_ports "c0_ddr4_dm_n[2]" ]
set_property PACKAGE_PIN U61 [ get_ports "c0_ddr4_dq[11]" ]
set_property PACKAGE_PIN V58 [ get_ports "c0_ddr4_dq[9]" ]
set_property PACKAGE_PIN AG62 [ get_ports "c0_ddr4_dqs_t[2]" ]
set_property PACKAGE_PIN AG63 [ get_ports "c0_ddr4_dqs_c[2]" ]
set_property PACKAGE_PIN AG58 [ get_ports "c0_ddr4_dq[19]" ]
set_property PACKAGE_PIN W60 [ get_ports "c0_ddr4_dm_n[1]" ]
set_property PACKAGE_PIN AF60 [ get_ports "c0_ddr4_dq[16]" ]
set_property PACKAGE_PIN AG61 [ get_ports "c0_ddr4_dq[17]" ]
set_property PACKAGE_PIN AA61 [ get_ports "c0_ddr4_dq[6]" ]
set_property PACKAGE_PIN AC55 [ get_ports "c0_ddr4_adr[0]" ]
set_property PACKAGE_PIN AC53 [ get_ports "c0_ddr4_adr[1]" ]
set_property PACKAGE_PIN AB51 [ get_ports "c0_ddr4_ck_t[0]" ]
#set_property PACKAGE_PIN AA51 [ get_ports "c0_ddr4_ck_t[1]" ]
set_property PACKAGE_PIN Y59 [ get_ports "c0_ddr4_dqs_t[0]" ]
set_property PACKAGE_PIN AA62 [ get_ports "c0_ddr4_dq[7]" ]
set_property PACKAGE_PIN AB61 [ get_ports "c0_ddr4_dm_n[0]" ]
set_property PACKAGE_PIN AC51 [ get_ports "c0_ddr4_adr[6]" ]
set_property PACKAGE_PIN AB52 [ get_ports "c0_ddr4_ck_c[0]" ]
#set_property PACKAGE_PIN AA52 [ get_ports "c0_ddr4_ck_c[1]" ]
#set_property PACKAGE_PIN AC45 [ get_ports "c0_ddr4_dq[68]" ]
set_property PACKAGE_PIN L54 [ get_ports "c0_ddr4_dq[60]" ]
set_property PACKAGE_PIN J52 [ get_ports "c0_ddr4_dq[61]" ]
set_property PACKAGE_PIN M51 [ get_ports "c0_ddr4_dq[58]" ]
set_property PACKAGE_PIN Y60 [ get_ports "c0_ddr4_dqs_c[0]" ]
set_property PACKAGE_PIN AA60 [ get_ports "c0_ddr4_dq[0]" ]
set_property PACKAGE_PIN AB59 [ get_ports "c0_ddr4_dq[4]" ]
set_property PACKAGE_PIN V53 [ get_ports "c0_ddr4_adr[7]" ]
set_property PACKAGE_PIN AB57 [ get_ports "c0_ddr4_adr[2]" ]
set_property PACKAGE_PIN AA56 [ get_ports "c0_ddr4_adr[4]" ]
#set_property PACKAGE_PIN AA45 [ get_ports "c0_ddr4_dqs_t[8]" ]
#set_property PACKAGE_PIN Y45 [ get_ports "c0_ddr4_dqs_c[8]" ]
#set_property PACKAGE_PIN AA47 [ get_ports "c0_ddr4_dq[69]" ]
set_property PACKAGE_PIN M52 [ get_ports "c0_ddr4_dq[62]" ]
set_property PACKAGE_PIN L51 [ get_ports "c0_ddr4_dq[59]" ]
set_property PACKAGE_PIN AA59 [ get_ports "c0_ddr4_dq[1]" ]
set_property PACKAGE_PIN AB58 [ get_ports "c0_ddr4_dq[5]" ]
set_property PACKAGE_PIN Y62 [ get_ports "c0_ddr4_dq[2]" ]
set_property PACKAGE_PIN Y63 [ get_ports "c0_ddr4_dq[3]" ]
set_property PACKAGE_PIN AB56 [ get_ports "c0_ddr4_adr[3]" ]
set_property PACKAGE_PIN AC54 [ get_ports "c0_ddr4_adr[5]" ]
set_property PACKAGE_PIN M53 [ get_ports "c0_ddr4_dm_n[7]" ]
set_property PACKAGE_PIN J51 [ get_ports "c0_ddr4_dq[63]" ]
set_property PACKAGE_PIN AA55 [ get_ports "c0_ddr4_cs_n[0]" ]
#set_property PACKAGE_PIN AA50 [ get_ports "c0_ddr4_cs_n[1]" ]
set_property PACKAGE_PIN AB54 [ get_ports "c0_ddr4_adr[16]" ]
set_property PACKAGE_PIN V56 [ get_ports "c0_ddr4_ba[0]" ]
set_property PACKAGE_PIN L52 [ get_ports "c0_ddr4_dq[56]" ]
set_property PACKAGE_PIN K52 [ get_ports "c0_ddr4_dqs_t[7]" ]
#set_property PACKAGE_PIN AA50 [ get_ports "DDR4_cs_n[1]" ]
set_property PACKAGE_PIN W56 [ get_ports "c0_ddr4_bg[0]" ]
set_property PACKAGE_PIN AA54 [ get_ports "c0_ddr4_adr[10]" ]
set_property PACKAGE_PIN Y54 [ get_ports "c0_ddr4_adr[11]" ]
set_property PACKAGE_PIN T56 [ get_ports "c0_ddr4_dq[44]" ]
set_property PACKAGE_PIN T54 [ get_ports "c0_ddr4_dqs_t[5]" ]
set_property PACKAGE_PIN P52 [ get_ports "c0_ddr4_dq[54]" ]
set_property PACKAGE_PIN P51 [ get_ports "c0_ddr4_dq[55]" ]
set_property PACKAGE_PIN K54 [ get_ports "c0_ddr4_dq[57]" ]
set_property PACKAGE_PIN K53 [ get_ports "c0_ddr4_dqs_c[7]" ]
set_property PACKAGE_PIN W55 [ get_ports "c0_ddr4_bg[1]" ]
set_property PACKAGE_PIN W53 [ get_ports "c0_ddr4_adr[12]" ]
set_property PACKAGE_PIN V51 [ get_ports "c0_ddr4_adr[13]" ]
set_property PACKAGE_PIN R54 [ get_ports "c0_ddr4_dq[42]" ]
set_property PACKAGE_PIN R58 [ get_ports "c0_ddr4_dq[45]" ]
set_property PACKAGE_PIN P56 [ get_ports "c0_ddr4_dq[40]" ]
set_property PACKAGE_PIN T55 [ get_ports "c0_ddr4_dqs_c[5]" ]
set_property PACKAGE_PIN U53 [ get_ports "c0_ddr4_dq[52]" ]
set_property PACKAGE_PIN T52 [ get_ports "c0_ddr4_dq[53]" ]
set_property PACKAGE_PIN N53 [ get_ports "c0_ddr4_dqs_t[6]" ]
set_property PACKAGE_PIN N54 [ get_ports "c0_ddr4_dqs_c[6]" ]
set_property PACKAGE_PIN AA49 [ get_ports "c0_ddr4_odt[0]" ]
#set_property PACKAGE_PIN Y48 [ get_ports "c0_ddr4_odt[1]" ]
set_property PACKAGE_PIN V54 [ get_ports "c0_ddr4_cke[0]" ]
#set_property PACKAGE_PIN Y50 [ get_ports "c0_ddr4_cke[1]" ]
set_property PACKAGE_PIN AC56 [ get_ports "c0_ddr4_adr[14]" ]
set_property PACKAGE_PIN AC50 [ get_ports "c0_ddr4_adr[8]" ]
set_property PACKAGE_PIN W52 [ get_ports "c0_ddr4_adr[9]" ]
set_property PACKAGE_PIN R55 [ get_ports "c0_ddr4_dq[43]" ]
set_property PACKAGE_PIN T57 [ get_ports "c0_ddr4_dq[41]" ]
set_property PACKAGE_PIN P55 [ get_ports "c0_ddr4_dq[46]" ]
set_property PACKAGE_PIN N51 [ get_ports "c0_ddr4_dq[50]" ]
set_property PACKAGE_PIN T51 [ get_ports "c0_ddr4_dq[51]" ]
set_property PACKAGE_PIN P53 [ get_ports "c0_ddr4_dq[48]" ]
set_property PACKAGE_PIN U52 [ get_ports "c0_ddr4_dq[49]" ]
set_property PACKAGE_PIN W57 [ get_ports "c0_ddr4_act_n" ]
set_property PACKAGE_PIN Y49 [ get_ports "c0_ddr4_reset_n" ]
#set_property PACKAGE_PIN Y50 [ get_ports "DDR4_cke[1]" ]
set_property PACKAGE_PIN V55 [ get_ports "c0_ddr4_adr[15]" ]
set_property PACKAGE_PIN AA57 [ get_ports "c0_ddr4_ba[1]" ]
set_property PACKAGE_PIN U56 [ get_ports "c0_ddr4_dm_n[5]" ]
set_property PACKAGE_PIN R57 [ get_ports "c0_ddr4_dq[47]" ]
set_property PACKAGE_PIN R52 [ get_ports "c0_ddr4_dm_n[6]" ]

####################################################################################
# Constraints from file : 'xiangshan.xdc'
####################################################################################

set_property SLEW FAST [get_ports c0_ddr4_reset_n]
set_property IOSTANDARD SSTL12_DCI [get_ports c0_ddr4_act_n]
set_property IOSTANDARD SSTL12_DCI [get_ports c0_ddr4_reset_n]


set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.GENERAL.CRC DISABLE [current_design]

####################################################################################
# Constraints from file : 'xiangshan.xdc'
####################################################################################


