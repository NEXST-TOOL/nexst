# NEXST: Next Environment for XiangShan Targets

NEXST provides a hardware and software environment for FPGA-based system-level prototyping and emulation platform with the open-source [XiangShan](https://github.com/OpenXiangShan/XiangShan) RISC-V processor.

```
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

## Supported XiangShan Targets

- **[Nanhu-G](https://github.com/OpenXiangShan/XiangShan/tree/nanhu-G)**: General version of Nanhu microarchitecture (second-generation XiangShan) for scientific research and education
- **[Kunminghu](https://github.com/OpenXiangShan/XiangShan)** ([Manual](https://docs.xiangshan.cc/projects/user-guide/zh-cn/latest/)): Kunminghu microarchitecture (third-generation XiangShan)

*For more information, please visit [XiangShan Documentation](https://xiangshan-doc.readthedocs.io)*

## Supported FPGA Boards

| Vendor | Board | FPGA Chip |
|----------|-----------|--|
| AMD/Xilinx | **[VCU128](https://www.xilinx.com/products/boards-and-kits/vcu128.html)** | VU37P |
| AMD/Xilinx | **[Alveo U280](https://www.amd.com/zh-cn/support/downloads/alveo-downloads.html/accelerators/alveo/u280.html)** | Similar to VU37P |
| ICT | **[NM37](./README.md#contact-us)** | VU37P |
| Corigine | **[MimicTurbo GT](https://www.corigine.com/products-MimicTurboGT.html)** | VU19P |
| ICT | **[NP19A](./README.md#contact-us)** | VU19P |

### FPGA Boards Selection Guide

## Compatibility Matrix

<!-- | Board | VCU128 | Alveo U280 | NM37 | MimicTurbo GT | NP19A |
|-------|--------|------------|------|---------------|-------|
| [FPGA_BD](./README.md#environment-configuration) string | `vcu128` | `u280` | `nm37` | `mimic_turbo` | `np19a` |
| Vivado version | 2024.2 | 2020.2 | 2024.2 | 2024.2 | 2024.2 |
| **Core Targets** | | | | | |
| Single-Core Nanhu-G | ✓ | ✓ | ✓ | ✓ | ✓ |
| Dual-Core Nanhu-G | × | × | × | ✓ | ✓ |
| Quad-Core Nanhu-G | × | × | × | ✓ | ✓ |
| Octa-Core Rocket | TBD | TBD | ✓ | ✓ | ✓ |
| Single-Core Kunminghu | × | × | × | ✓ | ✓ |
| **Board Features** | | | | | |
| M.2 Interface | × | × | ✓ | × | ✓ |
| RJ45 Interface | ✓ | × | ✓ | ✓ | ✓ |
| PCIe Card Format | Non-standard | ✓ | ✓ | ✓ | ✓ |
| DDR4 | 4.5GB | 32GB | 32GB | 16GB | 32GB | -->

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

## Prerequisites

- Ubuntu 20.04/22.04
- AMD/Xilinx Vivado 2020.2 (for U280) / 2024.2 (for others)

## Precompiled Binaries for Quick Demo

We have prepared some [precompiled binaries](https://github.com/NEXST-TOOL/ready_for_download) for a quick demo.

The structure of precompiled binaries are shown below:

```
.
├── nanhu-g-single         # for single-core XiangShan Nanhu-G
│   ├── vcu128             # for VCU128 board
│   │   ├── system.bit     # bitstream
│   │   ├── debug_nets.ltx # debug probes for mem and io axi bus
│   │   ├── bootrom.bin    # bootrom
│   │   └── RV_BOOT.bin    # boot image
│   ├── u280               # for U280 board
│   │   └── ...            # same content as VCU128
│   ├── nm37               # for NM37 board
│   ├── mimic_turbo        # for MimicTurbo GT board
│   └── np19a              # for NP19A board
├── nanhu-g-dual           # for dual-core XiangShan Nanhu-G
├── nanhu-g-quad           # for quad-core XiangShan Nanhu-G
├── kunminghu              # for XiangShan Kunminghu
└── rocket                 # for Rocket Chip
```

After downloading precompiled binaries, please follow the instructions in [FPGA Deployment](./README.md#fpga-deployment) section.

## Build from Scratch

### Install tools

```bash
sudo apt-get install openjdk-11-jdk device-tree-compiler gcc-riscv64-linux-gnu linux-headers-$(uname -r)

# Install Mill build tool
curl -L https://repo1.maven.org/maven2/com/lihaoyi/mill-dist/1.1.0-RC1/mill-dist-1.1.0-RC1-mill.sh -o mill
chmod +x mill && sudo mv mill /usr/local/bin
```

### Getting the code

```bash
git clone https://github.com/NEXST-TOOL/nexst
```

### Initial Setup

```bash
cd nexst

# Clone and initialize submodules
git submodule update --init --recursive

# Create workspace structure
mkdir -p work_farm/target/
cd work_farm/target && ln -s ../../nanhu-g nanhu-g
cd ../ && ln -s ../shell shell
ln -s ../tools/ tools
```

All subsequent build commands should be executed within the `work_farm` directory

### Environment Configuration

```bash
export VIVADO_VERSION=<2020.2|2024.2>
export VIVADO_TOOL_BASE=/path/to/your/vivado  # e.g., /opt/Vivado_2024.2
export FPGA_BD=your_board_string  # vcu128, u280, nm37, mimic_turbo, np19a
export NUM_CORES=<1|2|4> # Number of Nanhu-G cores in the system
```

### Hardware Generation

#### Nanhu-G Core Generation

```bash
make PRJ="target:nanhu-g" FPGA_BD=${FPGA_BD} xs_gen
```

#### FPGA Synthesis & Implementation

```bash
# Generate FPGA shell
make PRJ="shell:${FPGA_BD}" FPGA_BD=${FPGA_BD} FPGA_ACT=prj_gen vivado_prj
make PRJ="shell:${FPGA_BD}" FPGA_BD=${FPGA_BD} FPGA_ACT=run_syn vivado_prj

# Synthesize XiangShan role
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} FPGA_ACT=prj_gen vivado_prj
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} FPGA_ACT=run_syn vivado_prj

# Place & Route, Generate bitstream
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} FPGA_ACT=bit_gen vivado_prj
```

*Generated bitstream: `work_farm/hw_plat/target_nanhu-g_proto_${FPGA_BD}/system.bit`*

### Software Compilation

#### Boot ROM (ZSBL)

```bash
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} ARCH=riscv zsbl
```

*Bootrom: `nanhu-g/sw_plat/proto_${FPGA_BD}/bootrom.bin`*

#### Linux Boot Image

After modifying environment configuration, please run the following script to clean artifacts:

```bash
# Clean device tree
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} DT_TARGET=xiangshan target_dt_clean

# Clean Linux kernel
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} ARCH=riscv rootfs_clean
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} ARCH=riscv phy_os.os.distclean

# Clean opensbi
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} ARCH=riscv DT_TARGET=xiangshan opensbi_distclean
```

Run the following commands to generate `RV_BOOT.bin`

```bash
# Generate device tree
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} DT_TARGET=xiangshan target_dt

# Compile Linux kernel
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} ARCH=riscv phy_os.os

# Build OpenSBI boot image
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} ARCH=riscv DT_TARGET=xiangshan opensbi
```

*Boot images: `nanhu-g/sw_plat/proto_${FPGA_BD}/RV_BOOT.bin`*

### FPGA Deployment

#### Setup Hardware

- Install FPGA board in PCIe slot
- Ensure proper power supply
- Install AMD/Xilinx Vivado tools

#### Load XDMA Driver

```bash
# The following code are run in nexst directory

# Update XDMA Linux driver submodule
git submodule update --init tools/driver/xdma_drv

# Compile XDMA Linux driver
make -C tools/driver

# Load compiled XDMA driver
cd tools/driver/build && sudo insmod xdma.ko
```

#### Run Evaluation

```bash
# Program FPGA bitstream (system.bit) with Vivado

# Then load and run (exit with CTRL+\)
cd tools/proto
make
sudo ./load_and_run.sh xdma<N> </path/to/bootrom.bin> </path/to/RV_BOOT.bin>

# For serial console only (exit with CTRL+\)
sudo ./load_and_run.sh xdma<N>
```

### Summary of Output Artifact Locations

- **FPGA Bitstreams**: `work_farm/hw_plat/target_nanhu-g_proto_${FPGA_BD}/system.bit`
- **Bootroms**: `nanhu-g/sw_plat/proto_${FPGA_BD}/bootrom.bin`
- **Boot Images**: `nanhu-g/sw_plat/proto_${FPGA_BD}/RV_BOOT.bin`
- **Vivado Projects**: `work_farm/fpga/vivado_prj/`
- **Build Reports**: `work_farm/fpga/vivado_out/`

## Contact us

E-mail: <serve@ict.ac.cn>

## Cite us

Congwu Zhang, Panyu Wang, Yazhou Wang, Mingyu Chen, Yungang Bao, Yisong Chang and Ke Zhang. HeteroProto:
Automated RTL-to-Bitstream Framework for Heterogeneous Multi-FPGA SoC Prototyping, 2025 International
Conference on Field Programmable Technology (FPT), Shanghai, China, 2025.

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
