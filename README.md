# Kunminghu profile for NEXST

## Prerequisites 环境要求

- Ubuntu 20.04/22.04
- AMD/Xilinx Vivado 2020.2 (for U280) / 2024.2 (for others)

&nbsp;

- Ubuntu 20.04/22.04
- AMD/Xilinx Vivado 2020.2 (U280使用) / 2024.2 (其他板卡)

## Build from Scratch 从零构建

### Install tools 安装工具

```bash
sudo apt-get install openjdk-11-jdk device-tree-compiler gcc-riscv64-linux-gnu linux-headers-$(uname -r)

# Install Mill build tool
curl -L https://repo1.maven.org/maven2/com/lihaoyi/mill-dist/1.1.0-RC1/mill-dist-1.1.0-RC1-mill.sh -o mill
chmod +x mill && sudo mv mill /usr/local/bin
```

### Getting the code 获取代码

```bash
git clone https://github.com/NEXST-TOOL/nexst -b kunminghu
```

### Initial Setup 初始化配置

```bash
cd nexst

# Clone and initialize submodules 克隆并初始化子模块
git submodule update --init --recursive

# Create workspace structure 创建工作目录结构
mkdir -p work_farm/target/
cd work_farm/target && ln -s ../../kmh kmh
cd ../ && ln -s ../shell shell
ln -s ../tools/ tools
```

All subsequent build commands should be executed within the `work_farm` directory

下述指令在`work_farm`目录下运行

### Environment Configuration 环境配置

```bash
export VIVADO_VERSION=<2020.2|2024.2>
export VIVADO_TOOL_BASE=/path/to/your/vivado  # e.g., /opt/Vivado_2024.2
export FPGA_BD=your_board_string  # mimic_turbo, np19a
```

### Hardware Generation 硬件生成

#### Kunminghu Core Generation Kunminghu核心生成

```bash
make PRJ="target:kmh" FPGA_BD=${FPGA_BD} xs_gen
```

#### FPGA Synthesis & Implementation FPGA综合与实现

```bash
# Generate FPGA shell 生成FPGA shell设计
make PRJ="shell:${FPGA_BD}" FPGA_BD=${FPGA_BD} FPGA_ACT=prj_gen vivado_prj
make PRJ="shell:${FPGA_BD}" FPGA_BD=${FPGA_BD} FPGA_ACT=run_syn vivado_prj

# Synthesize XiangShan role 综合香山role设计
make PRJ="target:kmh:proto" FPGA_BD=${FPGA_BD} FPGA_ACT=prj_gen vivado_prj
make PRJ="target:kmh:proto" FPGA_BD=${FPGA_BD} FPGA_ACT=run_syn vivado_prj

# Place & Route, Generate bitstream 布局布线并生成比特流
make PRJ="target:kmh:proto" FPGA_BD=${FPGA_BD} FPGA_ACT=bit_gen vivado_prj
```

*Generated bitstream: `work_farm/hw_plat/target_kmh_proto_${FPGA_BD}/system.bit`*

*比特流位置: `work_farm/hw_plat/target_kmh_proto_${FPGA_BD}/system.bit`*

### Software Compilation 软件编译

#### Boot ROM (ZSBL) 第一阶段bootloader

```bash
make PRJ="target:kmh:proto" FPGA_BD=${FPGA_BD} ARCH=riscv zsbl
```

*Bootrom: `kmh/sw_plat/proto_${FPGA_BD}/bootrom.bin`*

#### Linux Boot Image Linux启动镜像

After modifying environment configuration, please run the following script to clean artifacts:

更改环境配置后，运行下述指令清理先前生成文件：

```bash
# Clean device tree 清理设备树
make PRJ="target:kmh:proto" FPGA_BD=${FPGA_BD} DT_TARGET=xiangshan target_dt_clean

# Clean Linux kernel 清理Linux内核
make PRJ="target:kmh:proto" FPGA_BD=${FPGA_BD} ARCH=riscv rootfs_clean
make PRJ="target:kmh:proto" FPGA_BD=${FPGA_BD} ARCH=riscv phy_os.os.distclean

# Clean OpenSBI 清理OpenSBI
make PRJ="target:kmh:proto" FPGA_BD=${FPGA_BD} ARCH=riscv DT_TARGET=xiangshan opensbi_distclean
```

Run the following commands to generate `RV_BOOT.bin`

运行下述目录生成`RV_BOOT.bin`文件

```bash
# Generate device tree 生成设备树
make PRJ="target:kmh:proto" FPGA_BD=${FPGA_BD} DT_TARGET=xiangshan target_dt

# Compile Linux kernel 生成Linux内核
make PRJ="target:kmh:proto" FPGA_BD=${FPGA_BD} ARCH=riscv phy_os.os

# Build OpenSBI boot image 构建OpenSBI启动镜像
make PRJ="target:kmh:proto" FPGA_BD=${FPGA_BD} ARCH=riscv DT_TARGET=xiangshan opensbi
```

*Boot images: `kmh/sw_plat/proto_${FPGA_BD}/RV_BOOT.bin`*

*启动镜像: `kmh/sw_plat/proto_${FPGA_BD}/RV_BOOT.bin`*

### FPGA Deployment FPGA部署

#### Setup Hardware 设置硬件

- Install FPGA board in PCIe slot
- Ensure proper power supply
- Install AMD/Xilinx Vivado tools

&nbsp;

- 将FPGA卡安装在PCIe槽内
- 确保电源供应
- 安装AMD/Xilinx Vivado工具

#### Load XDMA Driver 加载XDMA驱动

```bash
# The following code are run in nexst directory 下述代码在NEXST目录下运行

# Update XDMA Linux driver submodule 更新XDMA驱动子模块
git submodule update --init tools/driver/xdma_drv

# Compile XDMA Linux driver 编译XDMA Linux驱动
make -C tools/driver

# Load XDMA driver 加载XDMA驱动
cd tools/driver/build && sudo insmod xdma.ko
```

#### Run Evaluation 运行原型环境

```bash
# Program FPGA bitstream (system.bit) with Vivado 使用Vivado烧写比特流

# Then load and run (exit with CTRL+\) 加载并启动（使用CTRL+\退出）
cd tools/proto
make
sudo ./load_and_run.sh xdma<N> </path/to/bootrom.bin> </path/to/RV_BOOT.bin>

# For serial console only (exit with CTRL+\) 只连接串口（使用CTRL+\退出）
sudo ./load_and_run.sh xdma<N>
```

### Summary of Output Artifact Locations 文件位置总览

- **FPGA Bitstreams**: `work_farm/hw_plat/target_kmh_proto_${FPGA_BD}/system.bit`
- **Bootroms**: `kmh/sw_plat/proto_${FPGA_BD}/bootrom.bin`
- **Boot Images**: `kmh/sw_plat/proto_${FPGA_BD}/RV_BOOT.bin`
- **Vivado Projects**: `work_farm/fpga/vivado_prj/`
- **Build Reports**: `work_farm/fpga/vivado_out/`

&nbsp;

- **FPGA比特流**: `work_farm/hw_plat/target_kmh_proto_${FPGA_BD}/system.bit`
- **Bootroms**: `kmh/sw_plat/proto_${FPGA_BD}/bootrom.bin`
- **启动镜像**: `kmh/sw_plat/proto_${FPGA_BD}/RV_BOOT.bin`
- **Vivado工程**: `work_farm/fpga/vivado_prj/`
- **构建报告**: `work_farm/fpga/vivado_out/`

## Contact us 联系我们

E-mail: <serve@ict.ac.cn>

## Cite us 相关论文

Congwu Zhang, Panyu Wang, Yazhou Wang, Mingyu Chen, Yungang Bao, Yisong Chang and Ke Zhang. HeteroProto: Automated RTL-to-Bitstream Framework for Heterogeneous Multi-FPGA SoC Prototyping, 2025 International Conference on Field Programmable Technology (FPT), Shanghai, China, 2025.

```bibtex
@inproceedings{hetroproto,
 address = {Shanghai, China},
 title = {HeteroProto: Automated RTL-to-Bitstream Framework for Heterogeneous Multi-FPGA SoC Prototyping},
 shorttitle = {HeteroProto},
 booktitle = {2025 International Conference on Field Programmable Technology (ICFPT)},
 author = {Zhang, Congwu and Wang, Panyu and Wang, Yazhou and Chen, Mingyu and Bao, Yungang and Chang, Yisong and Zhang, Ke},
 month = dec,
 year = {2025},
}
```
