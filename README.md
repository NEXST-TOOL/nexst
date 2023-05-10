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
`cd work_farm/target && ln -s ../../nanhu-g nanhu-g`   
`cd ../ && ln -s ../shell shell` 

3. Install Linux kernel header on the x86 server 
side where the FPGA board/card is attached

4. All compilation operations are launched in the directory of `work_farm`

# Hardware Generation (including Nanhu-G core and its SoC wrapper)

## Nanhu-G compilation

`make PRJ="target:nanhu-g" FPGA_BD=vcu128 xs_gen`

## Compilation of ZSBL image leveraged in Boot ROM (To add)

`make PRJ="target:nanhu-g:proto" FPGA_BD=vcu128 ARCH=riscv zsbl`   

    The bootrom.bin is located in
    `nanhu-g/ready_for_download/proto_vcu128/`

## FPGA design flow

### FPGA Wrapper generation   
`make PRJ="shell:vcu128" FPGA_BD=vcu128 FPGA_ACT=prj_gen vivado_prj`    
`make PRJ="shell:vcu128" FPGA_BD=vcu128 FPGA_ACT=run_syn vivado_prj`   

### Xiangshan FPGA synthesis  
`make PRJ="target:nanhu-g:proto" FPGA_BD=vcu128 FPGA_ACT=prj_gen vivado_prj`   
`make PRJ="target:nanhu-g:proto" FPGA_BD=vcu128 FPGA_ACT=run_syn vivado_prj`

### FPGA Bitstream generation  
`make PRJ="target:nanhu-g:proto" FPGA_BD=vcu128 FPGA_ACT=bit_gen vivado_prj`

    The bitstream file is located in   
    `nanhu-g/ready_for_download/proto_vcu128/`
    
    Log files, timing/utilization reports and 
    design checkpoint files (.dcp) generated during Xilinx Vivado design flow 
    are located in   
    `work_farm/fpga/vivado_out/target_nanhu-g_proto_vcu128/` 
    
    Generated Vivado project of the SoC wrapper and target XiangShan 
    are located in  
    `work_farm/fpga/vivado_prj/shell_vcu128_vcu128/` and   
    `work_farm/fpga/vivado_prj/target_nanhu-g_proto_vcu128`, respectively.   

# RISC-V Side Software Compilation

## Linux boot via OpenSBI

### DTB generation
`make PRJ="target:nanhu-g:proto" FPGA_BD=vcu128 target_dt`   

### Linux kernel (v5.16) compilation
`make PRJ="target:nanhu-g:proto" FPGA_BD=vcu128 ARCH=riscv phy_os.os`   

### OpenSBI compilation (RV_BOOT.bin generation)
`make PRJ="target:nanhu-g:proto" FPGA_BD=vcu128 ARCH=riscv opensbi`   

    The boot image (i.e., RV_BOOT.bin) is located in
    `nanhu-g/ready_for_download/proto_vcu128/`

# FPGA evaluation flow

## Preparations

- Connect FPGA board to an x86 host machine via PCIe connector. Also connect the FPGA board power properly.

## Evaluation steps

<!-- TODO: xdma driver compilation -->

- Copy `bootrom.bin`, `RV_BOOT.bin` generated in the steps above and `tools/pcie-util` directory to the x86 host machine.

- Program the FPGA with `system.bit` generated in the steps above (in `nanhu-g/ready_for_download/proto_vcu128/`).

- Restart the x86 host machine to probe the FPGA as a PCIe device.

- Load XDMA driver.

    `sudo insmod xdma.ko`

    If successful, a series of `/dev/xdma<N>*` devices will be created (`<N>` is an assigned number), and detailed log can be viewed in `sudo dmesg`.

- Load images & run.

    Launch the following commands:
    ```sh
    cd pcie-util
    make # if pcie-util is not compiled
    sudo ./load_and_run.sh xdma<N> bootrom.bin RV_BOOT.bin # <N> is the assigned xdma device number
    ```

    This will reset the XiangShan core, load images and start the execution. At the end the serial is connected and the user can interact with the system running on XiangShan. To exit the serial connection, press the escape key CTRL+\\.

    To resume the serial connection without a system reset, use the following command:

    ```sh
    sudo ./load_and_run.sh xdma<N>
    ```
