# Introduction

The repository of NEXST (Next Environment for XiangShan Target) 
contains basic hardware and software components 
for system-level FPGA prototyping and emulation 
of the open-source XiangShan RISC-V processor core. 

The branch `Nanhu-mini-LvNA` mainly focuses on 
how to generate a prototyping for LvNA 
(Labeled von Neumann Architecture) with a dual-core 
XiangShan Nanhu-minimal processor.   

## XiangShan Targets with Nanhu Microarchitecture

- **Nanhu-minimal**, a minimal version of XiangShan NanHu

Note: Please refer to https://xiangshan-doc.readthedocs.io 
for more detailed information of Xiangshan Nanhu microarchitecture

## Fully-fledged and Cost-effective FPGA Environment

- **mimic_turbo**, a commercial development board with
the AMD/Xilinx Ultrascale+ VU19P FPGA chip 
(https://www.corigine.com/products-MimicTurboGT.html)

# Prerequisite

1. Download all required repository submodules

`git submodule update --init --recursive`   

2. Launch the following commands

`mkdir -p work_farm/target/`    
`cd work_farm/target && ln -s ../../nanhu-g nanhu-g`   
`cd ../ && ln -s ../shell shell`   
`ln -s ../tools/ tools`   
`cd software/linux && git checkout -b xilinx-v2022.2-lvna-dev origin/xilinx-v2022.2-lvna-dev`   
`cd -`

3. Install Linux kernel header on the x86 server 
side where the FPGA board/card is attached

4. All compilation operations are launched in the directory of `work_farm`

# Hardware Generation (including Nanhu-G core and its SoC wrapper)

## Nanhu-G compilation

`make PRJ="target:nanhu-g" FPGA_BD=mimic_turbo CONFIG=NohypeFPGAConfig NUM_CORES=2 xs_gen`

## FPGA design flow

### FPGA Wrapper generation   
`make PRJ="shell:mimic_turbo" FPGA_BD=mimic_turbo FPGA_ACT=prj_gen vivado_prj`    
`make PRJ="shell:mimic_turbo" FPGA_BD=mimic_turbo FPGA_ACT=run_syn vivado_prj`   

### Xiangshan FPGA synthesis  
`make PRJ="target:nanhu-g:proto" FPGA_BD=mimic_turbo FPGA_ACT=prj_gen vivado_prj`   
`make PRJ="target:nanhu-g:proto" FPGA_BD=mimic_turbo FPGA_ACT=run_syn vivado_prj`

### FPGA Bitstream generation  
`make PRJ="target:nanhu-g:proto" FPGA_BD=mimic_turbo FPGA_ACT=bit_gen vivado_prj`

    The bitstream file is located in   
    `nanhu-g/ready_for_download/proto_mimic_turbo/`
    
    Log files, timing/utilization reports and 
    design checkpoint files (.dcp) generated during Xilinx Vivado design flow 
    are located in   
    `work_farm/fpga/vivado_out/target_nanhu-g_proto_mimic_turbo/` 
    
    Generated Vivado project of the SoC wrapper and target XiangShan 
    are located in  
    `work_farm/fpga/vivado_prj/shell_mimic_turbo_mimic_turbo/` and   
    `work_farm/fpga/vivado_prj/target_nanhu-g_proto_mimic_turbo`, respectively.   

# RISC-V Side Software Compilation

## Compilation of ZSBL image leveraged in Boot ROM

`make PRJ="target:nanhu-g:proto" FPGA_BD=mimic_turbo ARCH=riscv zsbl`   

    The bootrom.bin is located in
    `nanhu-g/ready_for_download/proto_mimic_turbo/`

## Linux boot via OpenSBI

### DTB generation
`make PRJ="target:nanhu-g:proto" FPGA_BD=mimic_turbo DT_TARGET=XSTop_LvNA target_dt`   

### Linux kernel (v5.16) compilation
`make PRJ="target:nanhu-g:proto" FPGA_BD=mimic_turbo ARCH=riscv phy_os.os`   

### OpenSBI compilation (RV_BOOT.bin generation)
`make PRJ="target:nanhu-g:proto" FPGA_BD=mimic_turbo ARCH=riscv HART_COUNT=2 opensbi`

    The boot image (i.e., RV_BOOT.bin) is located in
    `nanhu-g/ready_for_download/proto_mimic_turbo/`

## New software workloads addition
The target software workload that is executable in the RISC-V Linux user-space 
must be installed in the directory `nanhu-g/software/rootfs/initramfs` 
and specified in the script file `nanhu-g/software/rootfs/scripts/gen-initramfs-list.sh`.     

It is the simplest approach to installing workloads 
to copy the target software binaries into the initramfs' 
`/bin` directory and add the workload name to the `BINS` array in `gen-initramfs-list.sh`.

# FPGA evaluation flow

## Setup of Hardware Environment

- Attach one of the target FPGA boards listed above 
  to a PCIe slot of one x86 host machine. 
  
  Please carefully check if the power supply of the PCIe-attached FPGA board is properly setup.

  AMD/Xilinx Vivado toolset must be installed on the x86 host.

## Compilation of x86-side PCIe XDMA Linux driver

### Clone this repository on the x86 host and update the submodule of shell/software/xdma_drv

### Driver compilation

`make PRJ="shell:mimic_turbo" xdma_drv`   

    The kernel module (i.e., xdma.ko) is located in
    `shell/software/build/xdma_drv/`

## Evaluation steps

- Copy `bootrom.bin`, `RV_BOOT.bin` generated in the steps above and `tools/proto` directory to the x86 host machine.

- Use Vivado toolset to program the FPGA with `system.bit` generated in the steps above (in `nanhu-g/ready_for_download/proto_mimic_turbo/`).

- Restart the x86 host machine to probe the FPGA as a PCIe device.

- Load XDMA driver.

    `cd shell/software/build/xdma_drv && sudo insmod xdma.ko`

    If successful, a series of `/dev/xdma<N>*` devices will be created (`<N>` is an assigned number), and detailed log can be viewed in `sudo dmesg`.

- Load images & run.

    Launch the following commands:
    ```sh
    cd tools/proto
    make # if proto is not compiled
    sudo ./load_and_run.sh xdma<N> bootrom.bin RV_BOOT.bin # <N> is the assigned xdma device number
    ```

    This will reset the XiangShan core, load images and start the execution. At the end the serial is connected and the user can interact with the system running on XiangShan. To exit the serial connection, press the escape key CTRL+\\.

    To resume the serial connection without a system reset, use the following command:

    ```sh
    sudo ./load_and_run.sh xdma<N>
    ```
## Labeling Feature Enabling

Labeling is a technique of attaching labels to applications. These labels can be passed from software to hardware, allowing the hardware to identify the source of memory access requests from a particular application. Additionally, there are some new hardware resource management components that enable users to manually set policies based on these labels for allocating hardware resources.

Launch the following commands in the Linux Console:

```sh
mount -t tmpfs cgroup_root /sys/fs/cgroup
mount -t cgroup -o dsid dsid /sys/fs/cgroup/dsid
```

This will mount and configure control groups (cgroups) to enable labeling.The token bucket-related parameters can be configured in `/sys/fs/cgroup/dsid/test-1/dsid.dsid-cp`.
