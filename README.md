# Software Compilation

## Prerequisite

1. Launch the following commands    
`mkdir -p work_farm/target/`    
`cd work_farm/target`    
`ln -s ../../nm37-xiangshan nm37-xiangshan` 

2. Install Linux kernel header on the x86 server 
side where the NM37 card is attached

3. All compilation operations are launched in the directory of `work_farm`

## QDMA driver compilation

1. PF version kernel module compilation for x86    
`make FPGA_PRJ="target:nm37-xiangshan" FPGA_BD=nf MODULE=mod_pf qdma_drv`

2. PF version kernel module cross-compilation for ARMv8     
`make FPGA_PRJ="target:nm37-xiangshan" FPGA_BD=nf MODULE=mod_pf TARGET_HOST=aarch64 qdma_drv`

    - **NOTE: FPGA_BD would be set to *nm37* in near future**

3. kernel module clean    
`make FPGA_PRJ="target:nm37-xiangshan" FPGA_BD=nf qdma_drv_clean`