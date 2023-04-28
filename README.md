# Introduction

The repository of NEXST (Next Environment for XiangShan Target) 
contains basic components for hardware-software 
system-level FPGA prototyping 
and emulation of the open-source 
XiangShan RISC-V processor core. 
Our current supported XiangShan target is a 
compact edition called Nanhu-G. 
The FPGA boards we leverage 
are Xilinx VCU128 and an ICT custom acceleration card named NM37, 
both of which are populated with Xilinx Ultrascale+ VU37P FPGA chips. 

# Prerequisite

1. Download all required repository submodules

`git submodule update --init --recursive`   

2. Launch the following commands

`mkdir -p work_farm/target/`    
`cd work_farm/target`    
`ln -s ../../nanhu-g nanhu-g` 

3. Install Linux kernel header on the x86 server 
side where the FPGA board/card is attached

4. All compilation operations are launched in the directory of `work_farm`

# Hardware Generation (including Nanhu-G core and its SoC wrapper)

## Nanhu-G compilation

`make PRJ="target:nanhu-g" FPGA_BD=vcu128 xs_gen`

# RISC-V Side Software Compilation

## Linux boot via OpenSBI

### DTB generation
`make PRJ="target:nanhu-g" FPGA_BD=vcu128 target_dt`   

### Linux kernel (v6.1) compilation
`make PRJ="target:nanhu-g" FPGA_BD=vcu128 ARCH=riscv phy_os.os`   

### OpenSBI compilation (RV_BOOT.bin generation)
`make PRJ="target:nanhu-g" FPGA_BD=vcu128 ARCH=riscv opensbi`   

    The boot image (i.e., RV_BOOT.bin) is located in
    `nanhu-g/ready_for_download/vcu128/`