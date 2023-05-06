# Introduction

The repository of NEXST (Next Environment for XiangShan Target) 
contains basic hardware and software components 
for system-level FPGA prototyping and emulation 
of the open-source XiangShan RISC-V processor core.

## XiangShan Targets with Nanhu Microarchitecture
- **Nanhu-G**, a compact version of XiangShan Nanhu   

- **Nanhu-minimal**, a minimal version of XiangShan NanHu

Note: Please refer to https://xiangshan-doc.readthedocs.io 
for more detailed information of Xiangshan Nanhu microarchitecture

## Fully-fledged and Cost-effective FPGA Environment
- **AMD/Xilinx VCU128**, a commercial development board with 
the AMD/Xilinx Ultrascale+ VU37P FPGA chip
(https://www.xilinx.com/products/boards-and-kits/vcu128.html) 

- **NM37**, a custom acceleration card designed by our team

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

### Linux kernel (v5.16) compilation
`make PRJ="target:nanhu-g" FPGA_BD=vcu128 ARCH=riscv phy_os.os`   

### OpenSBI compilation (RV_BOOT.bin generation)
`make PRJ="target:nanhu-g" FPGA_BD=vcu128 ARCH=riscv opensbi`   

    The boot image (i.e., RV_BOOT.bin) is located in
    `nanhu-g/ready_for_download/vcu128/`
