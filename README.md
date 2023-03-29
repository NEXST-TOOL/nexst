# Introduction

This repo contains basic components for prototyping 
and emulation of the reduced version (code name: Nanhu-G) 
of XiangShan RISC-V processor core. 
The target FPGA chip is Xilinx Ultrascale+ VU37P series. 
FPGA boards currently supported are Xilinx VCU128 and 
an ICT custom acceleration card named NM37. 

# Prerequisite

1. Launch the following commands    
`mkdir -p work_farm/target/`    
`cd work_farm/target`    
`ln -s ../../nm37-xiangshan nm37-xiangshan` 

2. Install Linux kernel header on the x86 server 
side where the FPGA board/card is attached

3. All compilation operations are launched in the directory of `work_farm`

# Hardware Generation (including Nanhu-G core and its wrapper)

## Nanhu-G compilation

`make FPGA_PRJ="target:nm37-xiangshan" FPGA_BD=nf xs_gen`

## Wrapper on Xilinx VCU128 board

The following commands should be executed instead because DFX flow has not been implemented yet:

1. Synthesize the shell:
`make FPGA_PRJ=shell FPGA_BD=vcu128 FPGA_ACT=prj_gen FPGA_VAL=xiangshan vivado_prj`
`make FPGA_PRJ=shell FPGA_BD=vcu128 FPGA_ACT=run_syn FPGA_VAL=xiangshan vivado_prj`

2. Synthesize the role (for XiangShan FPGA prototyping):
`make FPGA_PRJ="target:nm37-xiangshan" FPGA_BD=vcu128 FPGA_ACT=prj_gen FPGA_VAL=proto vivado_prj`
`make FPGA_PRJ="target:nm37-xiangshan" FPGA_BD=vcu128 FPGA_ACT=run_syn FPGA_VAL=proto vivado_prj`

3. Generate a full bitstream:
`make FPGA_PRJ=shell FPGA_BD=vcu128 FPGA_ACT=bit_gen FPGA_VAL=xiangshan vivado_prj`

<!-- 
1. Squencially launch the following commands to generate a bitstream file    
`make FPGA_PRJ=shell FPGA_BD=vcu128 FPGA_ACT=prj_gen FPGA_VAL=xiangshan vivado_prj`
`make FPGA_PRJ=shell FPGA_BD=vcu128 FPGA_ACT=run_syn FPGA_VAL=xiangshan vivado_prj`
`make FPGA_PRJ=shell FPGA_BD=vcu128 FPGA_ACT=bit_gen FPGA_VAL=xiangshan vivado_prj`
 -->

    The bitstream file is located in   
    `work_farm/hw_plat/shell_xiangshan_vcu128/`    

    Log files, timing/utilization reports and 
    design checkpoint files (.dcp) generated during Xilinx Vivado design flow 
    are located in   
    `work_farm/fpga/vivado_out/shell_xiangshan_vcu128/shell_xiangshan` 

## Wrapper on ICT's NM37 card (to be added) 

# Software Compilation

## QDMA driver compilation

1. PF version kernel module compilation for x86    
`make FPGA_PRJ="target:nm37-xiangshan" FPGA_BD=nf MODULE=mod_pf qdma_drv`

2. PF version kernel module cross-compilation for ARMv8     
`make FPGA_PRJ="target:nm37-xiangshan" FPGA_BD=nf MODULE=mod_pf TARGET_HOST=aarch64 qdma_drv`

    Before module compilation, Linux kernel deployed on ARMv8 would be cross-compiled first using    
    `make FPGA_PRJ=shell FPGA_BD=nf phy_os.os`

3. kernel module clean    
`make FPGA_PRJ="target:nm37-xiangshan" FPGA_BD=nf qdma_drv_clean`
    
- **NOTE: FPGA_BD would be set to *nm37* in near future**