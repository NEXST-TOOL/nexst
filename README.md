# Introduction

This repo contains basic components for FPGA prototyping 
and emulation of the reduced version of 
XiangShan RISC-V processor core (code name: Nanhu-G). 
The target FPGA chip is Xilinx Ultrascale+ VU37P series. 
FPGA boards currently supported are Xilinx VCU128 and 
an ICT custom acceleration card named NM37. 

# Prerequisite

1. Download all required repository submodules

`git submodule update --init --recursive`   

2. Launch the following commands

`mkdir -p work_farm/target/`    
`cd work_farm/target`    
`ln -s ../../nm37-xiangshan nm37-xiangshan` 

3. Install Linux kernel header on the x86 server 
side where the FPGA board/card is attached

4. All compilation operations are launched in the directory of `work_farm`

# Hardware Generation (including Nanhu-G core and its wrapper)

## Nanhu-G compilation

`make PRJ="target:nm37-xiangshan" FPGA_BD=vcu128 xs_gen`

# RISC-V Side Software Compilation

## Linux boot via OpenSBI

### DTB generation
`make PRJ="target:nm37-xiangshan" FPGA_BD=vcu128 target_dt`   

### Linux kernel (v6.1) compilation
`make PRJ="target:nm37-xiangshan" FPGA_BD=vcu128 ARCH=riscv phy_os.os`   

### OpenSBI compilation (RV_BOOT.bin generation)
`make PRJ="target:nm37-xiangshan" FPGA_BD=vcu128 ARCH=riscv opensbi`   

    The boot image (i.e., RV_BOOT.bin) is located in
    `nm37-xiangshan/ready_for_download/vcu128/`