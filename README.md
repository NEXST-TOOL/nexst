# NEXST: Next Environment for XiangShan Targets

NEXST provides a hardware and software environment for FPGA-based system-level prototyping and emulation platform with the open-source [XiangShan](https://github.com/OpenXiangShan/XiangShan) RISC-V processor.

NEXST为开源RISC-V处理器[香山](https://github.com/OpenXiangShan/XiangShan)提供了基于FPGA的系统级原型环境。

```raw
┌─────────────────────────┐
│     SERVE Platform      │
│┌───────────────────────┐│
││   NEXST Environment   ││
││┌─────────────────────┐││
│││      REMU Tool      │││
│││┌───────────────────┐│││
││││ XiangShan Core(s) ││││
│││└───────────────────┘│││
││└─────────────────────┘││
│└───────────────────────┘│
└─────────────────────────┘
```

## Supported XiangShan Targets 支持的香山核心

- **[Nanhu-G](https://github.com/OpenXiangShan/XiangShan/tree/nanhu-G)**: General version of Nanhu microarchitecture (second-generation XiangShan) for scientific research and education
- **[Kunminghu](https://github.com/OpenXiangShan/XiangShan)** ([Manual](https://docs.xiangshan.cc/projects/user-guide/zh-cn/latest/)): Kunminghu microarchitecture (third-generation XiangShan)

*For more information, please visit [XiangShan Documentation](https://xiangshan-doc.readthedocs.io)*

- **[Nanhu-G](https://github.com/OpenXiangShan/XiangShan/tree/nanhu-G)**: 面向科研与教育的通用南湖微架构（第二代香山处理器）。
- **[Kunminghu](https://github.com/OpenXiangShan/XiangShan)** ([手册](https://docs.xiangshan.cc/projects/user-guide/zh-cn/latest/)): 昆明湖微架构（第三代香山处理器）。

*更多信息请参见[香山文档](https://xiangshan-doc.readthedocs.io)*

## Supported FPGA Boards 支持的FPGA开发板

| Vendor | Board | FPGA Chip |
|----------|-----------|--|
| ICT | **[NP19A](./README.md#contact-us)** | VU19P |
| Corepilot | **[MimicTurbo GT](https://www.corigine.com/products-MimicTurboGT.html)** | VU19P |
| ICT | **[NM37](./README.md#contact-us)** | VU37P |
| AMD/Xilinx | **[Alveo U280](https://www.amd.com/zh-cn/support/downloads/alveo-downloads.html/accelerators/alveo/u280.html)** | Similar to VU37P |
| AMD/Xilinx | **[VCU128](https://www.xilinx.com/products/boards-and-kits/vcu128.html)** | VU37P |
| AMD/Xilinx | **[VCU1525](https://www.amd.com/zh-cn/products/adaptive-socs-and-fpgas/evaluation-boards/vcu1525-p.html)** | VU9P |

### FPGA Boards Selection Guide

## Board Compatibility Matrix 板卡适配

<table tabindex="0">
  <thead>
    <tr>
      <th colspan="2">Board</th>
      <th>VCU128</th>
      <th>Alveo U280</th>
      <th>NM37</th>
      <th>MimicTurbo GT</th>
      <th>NP19A</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center" colspan="2"><a href="./README.md#environment-configuration">FPGA_BD</a> string</td>
      <td><code>vcu128</code></td>
      <td><code>u280</code></td>
      <td><code>nm37</code></td>
      <td><code>mimic_turbo</code></td>
      <td><code>np19a</code></td>
    </tr>
    <tr>
      <td align="center" colspan="2">Vivado version</td>
      <td>2024.2</td>
      <td>2020.2</td>
      <td>2024.2</td>
      <td>2024.2</td>
      <td>2024.2</td>
    </tr>
    <tr>
      <td rowspan="5"><strong>Core</br>Targets</strong></td>
      <td>Single-Core Nanhu-G</td>
      <td>✓</td>
      <td>✓</td>
      <td>✓</td>
      <td>✓</td>
      <td>✓</td>
    </tr>
    <tr>
      <td>Dual-Core Nanhu-G</td>
      <td>×</td>
      <td>×</td>
      <td>×</td>
      <td>✓</td>
      <td>✓</td>
    </tr>
    <tr>
      <td>Quad-Core Nanhu-G</td>
      <td>×</td>
      <td>×</td>
      <td>×</td>
      <td>✓</td>
      <td>✓</td>
    </tr>
    <tr>
      <td>Octa-Core Rocket</td>
      <td>TBD</td>
      <td>TBD</td>
      <td>✓</td>
      <td>✓</td>
      <td>✓</td>
    </tr>
    <tr>
      <td>Single-Core Kunminghu</td>
      <td>×</td>
      <td>×</td>
      <td>×</td>
      <td>✓</td>
      <td>✓</td>
    </tr>
    <tr>
      <td rowspan="4"><strong>Board</br>Features</strong></td>
      <td>M.2 Interface</td>
      <td>×</td>
      <td>×</td>
      <td>✓</td>
      <td>×</td>
      <td>✓</td>
    </tr>
    <tr>
      <td>RJ45 Interface</td>
      <td>✓</td>
      <td>×</td>
      <td>✓</td>
      <td>✓</td>
      <td>✓</td>
    </tr>
    <tr>
      <td>PCIe Card Format</td>
      <td>Non-standard</td>
      <td>✓</td>
      <td>✓</td>
      <td>✓</td>
      <td>✓</td>
    </tr>
    <tr>
      <td>DDR4</td>
      <td>4.5GB</td>
      <td>32GB</td>
      <td>32GB</td>
      <td>16GB</td>
      <td>32GB</td>
    </tr>
  </tbody>
</table>

## Prerequisites 环境要求

- Ubuntu 20.04/22.04
- AMD/Xilinx Vivado 2020.2 (for U280) / 2024.2 (for others)

&nbsp;

- Ubuntu 20.04/22.04
- AMD/Xilinx Vivado 2020.2 (U280使用) / 2024.2 (其他板卡)

## Precompiled Binaries for Quick Demo

We have prepared some [precompiled binaries](https://github.com/NEXST-TOOL/ready_for_download) for a quick demo.

我们准备了一些[预编译二进制](https://github.com/NEXST-TOOL/ready_for_download)可用于快速DEMO测试。

The structure of precompiled binaries are shown below:

预编译二进制以下述文件结构组织：

```
.
├── nanhu-g-single         # for single-core XiangShan Nanhu-G    单核Nanhu-G处理器核心
│   ├── vcu128             # for VCU128 board                     VCU128开发板
│   │   ├── system.bit     # bitstream                            比特流
│   │   ├── debug_nets.ltx # debug probes for mem and io axi bus  mem和io axi接口的调试文件
│   │   ├── bootrom.bin    # bootrom
│   │   └── RV_BOOT.bin    # boot image                           启动镜像
│   ├── u280               # for U280 board                       U280加速卡
│   │   └── ...            # same content as VCU128               与VCU128的内容相同
│   ├── nm37               # for NM37 board                       NM37开发板
│   │   └── ...
│   ├── mimic_turbo        # for MimicTurbo GT board              MimicTurbo GT开发板
│   │   └── ...
│   └── np19a              # for NP19A board                      NP19A开发板
│   │   └── ...
├── nanhu-g-dual           # for dual-core XiangShan Nanhu-G      双核香山Nanhu-G处理器核心
│   └── ....
├── nanhu-g-quad           # for quad-core XiangShan Nanhu-G      四核香山Nanhu-G处理器核心
│   └── ....
├── kunminghu              # for single-core XiangShan Kunminghu  单核核香山Nanhu-G处理器核心
│   └── ....
└── rocket                 # for Rocket Chip                      Rocket处理器核心
    └── ....
```

After downloading precompiled binaries, please follow the instructions in [FPGA Deployment](./README.md#fpga-deployment) section.

在下载预编译二进制后，请遵循[FPGA Deployment](./README.md#fpga-deployment)节的指引完成香山的部署与启动流程。

## Build from Scratch 从头构建

### Install tools 安装工具

```bash
sudo apt-get install openjdk-11-jdk device-tree-compiler gcc-riscv64-linux-gnu linux-headers-$(uname -r)

# Install Mill build tool
curl -L https://repo1.maven.org/maven2/com/lihaoyi/mill-dist/1.1.0-RC1/mill-dist-1.1.0-RC1-mill.sh -o mill
chmod +x mill && sudo mv mill /usr/local/bin
```

### Getting the code 获取代码

```bash
git clone https://github.com/NEXST-TOOL/nexst
```

### Initial Setup 初始化配置

```bash
cd nexst

# Clone and initialize submodules 克隆并初始化子模块
git submodule update --init --recursive

# Create workspace structure 创建工作目录结构
mkdir -p work_farm/target/
cd work_farm/target && ln -s ../../nanhu-g nanhu-g
cd ../ && ln -s ../shell shell
ln -s ../tools/ tools
```

All subsequent build commands should be executed within the `work_farm` directory

下述指令在`work_farm`目录下运行

### Environment Configuration 环境配置

```bash
export VIVADO_VERSION=<2020.2|2024.2>
export VIVADO_TOOL_BASE=/path/to/your/vivado  # e.g., /opt/Vivado_2024.2
export FPGA_BD=your_board_string  # vcu128, u280, nm37, mimic_turbo, np19a
export NUM_CORES=<1|2|4> # Number of Nanhu-G cores in the system 系统中Nanhu-G的核心数
```

### Hardware Generation 硬件生成

#### Nanhu-G Core Generation Nanhu-G核心生成

```bash
make PRJ="target:nanhu-g" FPGA_BD=${FPGA_BD} xs_gen
```

#### FPGA Synthesis & Implementation FPGA综合与实现

```bash
# Generate FPGA shell 生成FPGA shell设计
make PRJ="shell:${FPGA_BD}" FPGA_BD=${FPGA_BD} FPGA_ACT=prj_gen vivado_prj
make PRJ="shell:${FPGA_BD}" FPGA_BD=${FPGA_BD} FPGA_ACT=run_syn vivado_prj

# Synthesize XiangShan role 综合香山role设计
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} FPGA_ACT=prj_gen vivado_prj
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} FPGA_ACT=run_syn vivado_prj

# Place & Route, Generate bitstream 布局布线并生成比特流
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} FPGA_ACT=bit_gen vivado_prj
```

*Generated bitstream: `work_farm/hw_plat/target_nanhu-g_proto_${FPGA_BD}/system.bit`*

*比特流位置: `work_farm/hw_plat/target_nanhu-g_proto_${FPGA_BD}/system.bit`*

### Software Compilation 软件编译

#### Boot ROM (ZSBL) 第一阶段bootloader

```bash
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} ARCH=riscv zsbl
```

*Bootrom: `nanhu-g/sw_plat/proto_${FPGA_BD}/bootrom.bin`*

#### Linux Boot Image Linux启动镜像

After modifying environment configuration, please run the following script to clean artifacts:

更改环境配置后，运行下述指令清理先前生成文件：

```bash
# Clean device tree 清理设备树
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} DT_TARGET=xiangshan target_dt_clean

# Clean Linux kernel 清理Linux内核
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} ARCH=riscv rootfs_clean
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} ARCH=riscv phy_os.os.distclean

# Clean OpenSBI 清理OpenSBI
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} ARCH=riscv DT_TARGET=xiangshan opensbi_distclean
```

Run the following commands to generate `RV_BOOT.bin`

运行下述目录生成`RV_BOOT.bin`文件

```bash
# Generate device tree 生成设备树
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} DT_TARGET=xiangshan target_dt

# Compile Linux kernel 生成Linux内核
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} ARCH=riscv phy_os.os

# Build OpenSBI boot image 构建OpenSBI启动镜像
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} ARCH=riscv DT_TARGET=xiangshan opensbi
```

*Boot images: `nanhu-g/sw_plat/proto_${FPGA_BD}/RV_BOOT.bin`*

*启动镜像: `nanhu-g/sw_plat/proto_${FPGA_BD}/RV_BOOT.bin`*

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

- **FPGA Bitstreams**: `work_farm/hw_plat/target_nanhu-g_proto_${FPGA_BD}/system.bit`
- **Bootroms**: `nanhu-g/sw_plat/proto_${FPGA_BD}/bootrom.bin`
- **Boot Images**: `nanhu-g/sw_plat/proto_${FPGA_BD}/RV_BOOT.bin`
- **Vivado Projects**: `work_farm/fpga/vivado_prj/`
- **Build Reports**: `work_farm/fpga/vivado_out/`

- **FPGA比特流**: `work_farm/hw_plat/target_nanhu-g_proto_${FPGA_BD}/system.bit`
- **Bootroms**: `nanhu-g/sw_plat/proto_${FPGA_BD}/bootrom.bin`
- **启动镜像**: `nanhu-g/sw_plat/proto_${FPGA_BD}/RV_BOOT.bin`
- **Vivado工程**: `work_farm/fpga/vivado_prj/`
- **构建报告**: `work_farm/fpga/vivado_out/`

## Contact us 联系我们

E-mail: <serve@ict.ac.cn>

## Cite us 引用我们

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
