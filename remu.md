# Prerequisite

1. All Prerequisites in `README.md`

2. Compile REMU framework

`` make -C tools/remu ``

# Hardware Generation

## Nanhu-G compilation

`make PRJ="target:nanhu-g" FPGA_BD=<board> xs_gen`

## REMU transformation

`make PRJ="target:nanhu-g" FPGA_BD=<board> remu_transform`

## FPGA design flow

### FPGA Wrapper generation   
`make PRJ="shell:<board>" FPGA_BD=<board> FPGA_ACT=prj_gen vivado_prj`    
`make PRJ="shell:<board>" FPGA_BD=<board> FPGA_ACT=run_syn vivado_prj`   

### Xiangshan FPGA synthesis  
`make PRJ="target:nanhu-g:remu" FPGA_BD=<board> FPGA_ACT=prj_gen vivado_prj`   
`make PRJ="target:nanhu-g:remu" FPGA_BD=<board> FPGA_ACT=run_syn vivado_prj`

### FPGA Bitstream generation  
`make PRJ="target:nanhu-g:remu" FPGA_BD=<board> FPGA_ACT=bit_gen vivado_prj`

    The bitstream file is located in   
    `nanhu-g/ready_for_download/remu_<board>/`

# RISC-V Side Software Compilation

As in `README.md`. 

# FPGA evaluation flow

## Setup of Hardware Environment

As in `README.md`. 

## Compilation of x86-side PCIe XDMA Linux driver

As in `README.md`.

## Evaluation steps

- Copy `remu-driver` and `remu-cpedit` in `tools/remu/install/bin` to the x86 host machine. 
If these binaries fail to work, recompile REMU framework on the host machine. 

- Copy `bootrom.bin`, `RV_BOOT.bin` generated in the steps above to the x86 host machine.

- Copy `sysinfo.json` and `ckpt` folder in `nanhu-g/hardware/remu_out` to the x86 host machine.

- Use Vivado toolset to program the FPGA with `system.bit` generated in the steps above.

- Restart the x86 host machine to probe the FPGA as a PCIe device.

- Load XDMA driver.

    `cd shell/software/build/xdma_drv && sudo insmod xdma.ko`

    If successful, a series of `/dev/xdma<N>*` devices will be created (`<N>` is an assigned number), and detailed log can be viewed in `sudo dmesg`.

- Load images into the initial checkpoint.

    `./remu-cpedit sysinfo.json ckpt`

    In the command prompt, enter the following commands:

    ```
    axi import EMU_TOP.u_rammodel.backend.host_axi RV_BOOT.bin
    save
    exit
    ```

    <!-- Note: loading bootrom is currently unsupported -->

- Prepare the platform description file.

    Sample description files are in `tools/remu/platform-sample`. 
    Choose the file corresponding to the FPGA board and change the XDMA name to the actual device. 
    This file is referred as `platinfo.yml` in the steps below. 

- Run emulation.

    `sudo ./remu-driver sysinfo.json platinfo.yml ckpt`

    Execute the following sequence of commands to generate a 10-cycle reset:

    ```
    signal EMU_TOP.rst 1
    run 10
    signal EMU_TOP.rst 0
    ```

    Then type `run` to continue emulation. 
    Press CTRL+C to pause when emulation is running. 

    Type `save` to save a checkpoint at any cycle. 

    To remove checkpoints after a specified cycle and rerun, type `record <cycle>`.
 
    To replay emulation on FPGA from a specified cycle, type `replay <cycle>`. 

- Reconstruct waveform.

    Copy the `ckpt` folder from host machine to local machine (`nanhu-g/hardware/remu_out`). 

    `make PRJ="target:nanhu-g" FPGA_BD=<board> TICK=<checkpoint cycle> DURATION=<waveform duration> remu_replay`

    Use GTKwave to open the generated waveform file (`nanhu-g/hardware/remu_out/replay.fst`).
