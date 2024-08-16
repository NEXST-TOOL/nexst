export RISCV=/data/hty/tools/old-riscv-gcc
export PATH=$RISCV/bin:$PATH

cd work_farm
make PRJ="target:nanhu-g:proto" FPGA_BD=vcu128 ARCH=riscv zsbl
make PRJ="target:nanhu-g:proto" FPGA_BD=vcu128 DT_TARGET=XSTop_pci target_dt
make PRJ="target:nanhu-g:proto" FPGA_BD=vcu128 ARCH=riscv phy_os.os
make PRJ="target:nanhu-g:proto" FPGA_BD=vcu128 ARCH=riscv DT_TARGET=XSTop_pci opensbi
cd ..
