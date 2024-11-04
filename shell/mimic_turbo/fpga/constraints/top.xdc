#========================================================
# Top-level constraint file for Xiangshan on VCU128
# Based on Vivado 2020.2
# Author: Yisong Chang (changyisong@ict.ac.cn)
# Date: 11/01/2023
#========================================================

# PCIe EP GT reference clock
create_clock -period 10.000 -name pcie_ep_ref_clk -waveform {0.000 5.000} [get_ports pcie_ep_gt_ref_clk_clk_p]

set_property PACKAGE_PIN BL15 [get_ports {pcie_ep_gt_ref_clk_clk_p[0]}]

# PL DDR reference clock
create_clock -period 4.000 -name ddr4_mig_sys_clk -waveform {0.000 2.000} [get_ports ddr4_mig_sys_clk_clk_p]

set_property IOSTANDARD DIFF_SSTL12 [get_ports ddr4_mig_sys_clk_clk_n]
set_property IOSTANDARD DIFF_SSTL12 [get_ports ddr4_mig_sys_clk_clk_p]

set_property PACKAGE_PIN P56 [get_ports ddr4_mig_sys_clk_clk_n]
set_property PACKAGE_PIN P55 [get_ports ddr4_mig_sys_clk_clk_p]

# PCIe EP perstn physical location
set_property PACKAGE_PIN BK34 [get_ports pcie_ep_perstn]
set_property IOSTANDARD LVCMOS12 [get_ports pcie_ep_perstn]

# LED
# set_property PACKAGE_PIN BH24 [get_ports ddr4_mig_calib_done]
# set_property IOSTANDARD LVCMOS18 [get_ports ddr4_mig_calib_done]

# set_property PACKAGE_PIN BG24 [get_ports pcie_ep_phy_ready]
# set_property IOSTANDARD LVCMOS18 [get_ports pcie_ep_phy_ready]

# set_property PACKAGE_PIN BG25 [get_ports pcie_ep_lnk_up]
# set_property IOSTANDARD LVCMOS18 [get_ports pcie_ep_lnk_up]

# DDR
set_property PACKAGE_PIN P54 [get_ports c0_ddr4_act_n]
set_property PACKAGE_PIN N52 [get_ports {c0_ddr4_adr[0]}]
set_property PACKAGE_PIN P52 [get_ports {c0_ddr4_adr[1]}]
set_property PACKAGE_PIN V54 [get_ports {c0_ddr4_adr[2]}]
set_property PACKAGE_PIN V53 [get_ports {c0_ddr4_adr[3]}]
set_property PACKAGE_PIN N54 [get_ports {c0_ddr4_adr[4]}]
set_property PACKAGE_PIN N53 [get_ports {c0_ddr4_adr[5]}]
set_property PACKAGE_PIN U54 [get_ports {c0_ddr4_adr[6]}]
set_property PACKAGE_PIN U53 [get_ports {c0_ddr4_adr[7]}]
set_property PACKAGE_PIN R53 [get_ports {c0_ddr4_adr[8]}]
set_property PACKAGE_PIN R52 [get_ports {c0_ddr4_adr[9]}]
set_property PACKAGE_PIN T53 [get_ports {c0_ddr4_adr[10]}]
set_property PACKAGE_PIN T52 [get_ports {c0_ddr4_adr[11]}]
set_property PACKAGE_PIN V56 [get_ports {c0_ddr4_adr[12]}]
set_property PACKAGE_PIN R55 [get_ports {c0_ddr4_adr[13]}]
set_property PACKAGE_PIN T55 [get_ports {c0_ddr4_adr[14]}]
set_property PACKAGE_PIN R57 [get_ports {c0_ddr4_adr[15]}]
set_property PACKAGE_PIN P57 [get_ports {c0_ddr4_adr[16]}]
set_property PACKAGE_PIN R54 [get_ports {c0_ddr4_ba[0]}]
set_property PACKAGE_PIN U56 [get_ports {c0_ddr4_ba[1]}]
set_property PACKAGE_PIN U55 [get_ports {c0_ddr4_bg[0]}]
set_property PACKAGE_PIN N57 [get_ports c0_ddr4_ck_c]
set_property PACKAGE_PIN N56 [get_ports c0_ddr4_ck_t]
set_property PACKAGE_PIN T56 [get_ports c0_ddr4_cke]
set_property PACKAGE_PIN T60 [get_ports c0_ddr4_cs_n]
set_property PACKAGE_PIN AH61 [get_ports {c0_ddr4_dm_n[0]}]
set_property PACKAGE_PIN AE62 [get_ports {c0_ddr4_dm_n[1]}]
set_property PACKAGE_PIN AB61 [get_ports {c0_ddr4_dm_n[2]}]
set_property PACKAGE_PIN Y62 [get_ports {c0_ddr4_dm_n[3]}]
set_property PACKAGE_PIN AC56 [get_ports {c0_ddr4_dm_n[4]}]
set_property PACKAGE_PIN AC54 [get_ports {c0_ddr4_dm_n[5]}]
set_property PACKAGE_PIN AB51 [get_ports {c0_ddr4_dm_n[6]}]
set_property PACKAGE_PIN Y47 [get_ports {c0_ddr4_dm_n[7]}]
set_property PACKAGE_PIN AH58 [get_ports {c0_ddr4_dq[0]}]
set_property PACKAGE_PIN AH59 [get_ports {c0_ddr4_dq[1]}]
set_property PACKAGE_PIN AH63 [get_ports {c0_ddr4_dq[2]}]
set_property PACKAGE_PIN AG63 [get_ports {c0_ddr4_dq[3]}]
set_property PACKAGE_PIN AF60 [get_ports {c0_ddr4_dq[4]}]
set_property PACKAGE_PIN AF61 [get_ports {c0_ddr4_dq[5]}]
set_property PACKAGE_PIN AG58 [get_ports {c0_ddr4_dq[6]}]
set_property PACKAGE_PIN AF58 [get_ports {c0_ddr4_dq[7]}]
set_property PACKAGE_PIN AF63 [get_ports {c0_ddr4_dq[8]}]
set_property PACKAGE_PIN AE63 [get_ports {c0_ddr4_dq[9]}]
set_property PACKAGE_PIN AC58 [get_ports {c0_ddr4_dq[10]}]
set_property PACKAGE_PIN AC59 [get_ports {c0_ddr4_dq[11]}]
set_property PACKAGE_PIN AD59 [get_ports {c0_ddr4_dq[12]}]
set_property PACKAGE_PIN AD60 [get_ports {c0_ddr4_dq[13]}]
set_property PACKAGE_PIN AD61 [get_ports {c0_ddr4_dq[14]}]
set_property PACKAGE_PIN AC61 [get_ports {c0_ddr4_dq[15]}]
set_property PACKAGE_PIN AB60 [get_ports {c0_ddr4_dq[16]}]
set_property PACKAGE_PIN AA60 [get_ports {c0_ddr4_dq[17]}]
set_property PACKAGE_PIN AC62 [get_ports {c0_ddr4_dq[18]}]
set_property PACKAGE_PIN AC63 [get_ports {c0_ddr4_dq[19]}]
set_property PACKAGE_PIN AB63 [get_ports {c0_ddr4_dq[20]}]
set_property PACKAGE_PIN AA63 [get_ports {c0_ddr4_dq[21]}]
set_property PACKAGE_PIN AA58 [get_ports {c0_ddr4_dq[22]}]
set_property PACKAGE_PIN Y58 [get_ports {c0_ddr4_dq[23]}]
set_property PACKAGE_PIN W59 [get_ports {c0_ddr4_dq[24]}]
set_property PACKAGE_PIN W60 [get_ports {c0_ddr4_dq[25]}]
set_property PACKAGE_PIN Y59 [get_ports {c0_ddr4_dq[26]}]
set_property PACKAGE_PIN Y60 [get_ports {c0_ddr4_dq[27]}]
set_property PACKAGE_PIN W61 [get_ports {c0_ddr4_dq[28]}]
set_property PACKAGE_PIN W62 [get_ports {c0_ddr4_dq[29]}]
set_property PACKAGE_PIN V58 [get_ports {c0_ddr4_dq[30]}]
set_property PACKAGE_PIN V59 [get_ports {c0_ddr4_dq[31]}]
set_property PACKAGE_PIN AA57 [get_ports {c0_ddr4_dq[32]}]
set_property PACKAGE_PIN Y57 [get_ports {c0_ddr4_dq[33]}]
set_property PACKAGE_PIN AB56 [get_ports {c0_ddr4_dq[34]}]
set_property PACKAGE_PIN AA56 [get_ports {c0_ddr4_dq[35]}]
set_property PACKAGE_PIN AB55 [get_ports {c0_ddr4_dq[36]}]
set_property PACKAGE_PIN AA55 [get_ports {c0_ddr4_dq[37]}]
set_property PACKAGE_PIN Y55 [get_ports {c0_ddr4_dq[38]}]
set_property PACKAGE_PIN W55 [get_ports {c0_ddr4_dq[39]}]
set_property PACKAGE_PIN Y54 [get_ports {c0_ddr4_dq[40]}]
set_property PACKAGE_PIN W54 [get_ports {c0_ddr4_dq[41]}]
set_property PACKAGE_PIN AC53 [get_ports {c0_ddr4_dq[42]}]
set_property PACKAGE_PIN AB53 [get_ports {c0_ddr4_dq[43]}]
set_property PACKAGE_PIN AA53 [get_ports {c0_ddr4_dq[44]}]
set_property PACKAGE_PIN Y53 [get_ports {c0_ddr4_dq[45]}]
set_property PACKAGE_PIN AA52 [get_ports {c0_ddr4_dq[46]}]
set_property PACKAGE_PIN Y52 [get_ports {c0_ddr4_dq[47]}]
set_property PACKAGE_PIN AB50 [get_ports {c0_ddr4_dq[48]}]
set_property PACKAGE_PIN AA50 [get_ports {c0_ddr4_dq[49]}]
set_property PACKAGE_PIN Y49 [get_ports {c0_ddr4_dq[50]}]
set_property PACKAGE_PIN W49 [get_ports {c0_ddr4_dq[51]}]
set_property PACKAGE_PIN Y50 [get_ports {c0_ddr4_dq[52]}]
set_property PACKAGE_PIN W50 [get_ports {c0_ddr4_dq[53]}]
set_property PACKAGE_PIN AA48 [get_ports {c0_ddr4_dq[54]}]
set_property PACKAGE_PIN Y48 [get_ports {c0_ddr4_dq[55]}]
set_property PACKAGE_PIN AC46 [get_ports {c0_ddr4_dq[56]}]
set_property PACKAGE_PIN AC47 [get_ports {c0_ddr4_dq[57]}]
set_property PACKAGE_PIN W45 [get_ports {c0_ddr4_dq[58]}]
set_property PACKAGE_PIN W46 [get_ports {c0_ddr4_dq[59]}]
set_property PACKAGE_PIN AA45 [get_ports {c0_ddr4_dq[60]}]
set_property PACKAGE_PIN Y45 [get_ports {c0_ddr4_dq[61]}]
set_property PACKAGE_PIN AB46 [get_ports {c0_ddr4_dq[62]}]
set_property PACKAGE_PIN AA46 [get_ports {c0_ddr4_dq[63]}]
set_property PACKAGE_PIN AG59 [get_ports {c0_ddr4_dqs_t[0]}]
set_property PACKAGE_PIN AG60 [get_ports {c0_ddr4_dqs_c[0]}]
set_property PACKAGE_PIN AE59 [get_ports {c0_ddr4_dqs_t[1]}]
set_property PACKAGE_PIN AE60 [get_ports {c0_ddr4_dqs_c[1]}]
set_property PACKAGE_PIN AB58 [get_ports {c0_ddr4_dqs_t[2]}]
set_property PACKAGE_PIN AB59 [get_ports {c0_ddr4_dqs_c[2]}]
set_property PACKAGE_PIN V61 [get_ports {c0_ddr4_dqs_t[3]}]
set_property PACKAGE_PIN V62 [get_ports {c0_ddr4_dqs_c[3]}]
set_property PACKAGE_PIN W56 [get_ports {c0_ddr4_dqs_t[4]}]
set_property PACKAGE_PIN W57 [get_ports {c0_ddr4_dqs_c[4]}]
set_property PACKAGE_PIN W51 [get_ports {c0_ddr4_dqs_t[5]}]
set_property PACKAGE_PIN W52 [get_ports {c0_ddr4_dqs_c[5]}]
set_property PACKAGE_PIN AC49 [get_ports {c0_ddr4_dqs_t[6]}]
set_property PACKAGE_PIN AB49 [get_ports {c0_ddr4_dqs_c[6]}]
set_property PACKAGE_PIN AC48 [get_ports {c0_ddr4_dqs_t[7]}]
set_property PACKAGE_PIN AB48 [get_ports {c0_ddr4_dqs_c[7]}]
set_property PACKAGE_PIN N59 [get_ports c0_ddr4_odt]
set_property PACKAGE_PIN AC57 [get_ports c0_ddr4_reset_n]

# SLR constraints

set_property USER_SLR_ASSIGNMENT SLR0 [get_cells xiangshan_i/xdma_ep]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells xiangshan_i/axi_ic_ddr_mem]

set_property USER_SLR_ASSIGNMENT SLR0 [get_cells xiangshan_i/axi_reg_slice_slr_xing/inst/aw16.aw_auto/slr_auto_src]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells xiangshan_i/axi_reg_slice_slr_xing/inst/w16.w_auto/slr_auto_src]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells xiangshan_i/axi_reg_slice_slr_xing/inst/ar16.ar_auto/slr_auto_src]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells xiangshan_i/axi_reg_slice_slr_xing/inst/r16.r_auto/slr_auto_dest]
set_property USER_SLR_ASSIGNMENT SLR0 [get_cells xiangshan_i/axi_reg_slice_slr_xing/inst/b16.b_auto/slr_auto_dest]

set_property USER_SLR_ASSIGNMENT SLR2 [get_cells xiangshan_i/axi_reg_slice_slr_xing/inst/aw16.aw_auto/slr_auto_dest]
set_property USER_SLR_ASSIGNMENT SLR2 [get_cells xiangshan_i/axi_reg_slice_slr_xing/inst/w16.w_auto/slr_auto_dest]
set_property USER_SLR_ASSIGNMENT SLR2 [get_cells xiangshan_i/axi_reg_slice_slr_xing/inst/ar16.ar_auto/slr_auto_dest]
set_property USER_SLR_ASSIGNMENT SLR2 [get_cells xiangshan_i/axi_reg_slice_slr_xing/inst/r16.r_auto/slr_auto_src]
set_property USER_SLR_ASSIGNMENT SLR2 [get_cells xiangshan_i/axi_reg_slice_slr_xing/inst/b16.b_auto/slr_auto_src]