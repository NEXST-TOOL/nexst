#! /bin/zsh
cd work_farm
make PRJ="target:nanhu-g" FPGA_BD=vcu128 xs_gen
make PRJ="shell:vcu128" FPGA_BD=vcu128 FPGA_ACT=prj_gen vivado_prj
make PRJ="shell:vcu128" FPGA_BD=vcu128 FPGA_ACT=run_syn vivado_prj
make PRJ="target:nanhu-g:proto" FPGA_BD=vcu128 FPGA_ACT=prj_gen vivado_prj
make PRJ="target:nanhu-g:proto" FPGA_BD=vcu128 FPGA_ACT=run_syn vivado_prj
make PRJ="target:nanhu-g:proto" FPGA_BD=vcu128 FPGA_ACT=bit_gen vivado_prj
cd ..