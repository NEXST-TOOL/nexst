# NEXST: Next Environment for XiangShan Target

NEXST provides a complete hardware and software environment for FPGA-based prototyping and emulation of the open-source XiangShan RISC-V processor.

## Supported XiangShan Targets

- **[Nanhu-G](https://github.com/OpenXiangShan/XiangShan/tree/nanhu-G)**: Modified version of XiangShan Nanhu microarchitecture for education and research
- **Nanhu-minimal**: Minimal XiangShan Nanhu implementation  
- **[Kunminghu](https://github.com/OpenXiangShan/XiangShan)**: Current main architecture of XiangShan

*For detailed microarchitecture information, visit [Xiangshan Documentation](https://xiangshan-doc.readthedocs.io)*

## Supported FPGA Platforms

| Platform | FPGA Chip | Key Features |
|----------|-----------|--------------|
| **Xilinx [VCU128](https://www.xilinx.com/products/boards-and-kits/vcu128.html)** | VU37P | Commercial development board |
| **Xilinx [Alveo U280](https://www.amd.com/zh-cn/support/downloads/alveo-downloads.html/accelerators/alveo/u280.html)** | VU37P | Data center accelerator card |
| **ICT NM37** | VU37P | Custom card with NVMe SSD support |
| **Corigine [MimicTurbo GT](https://www.corigine.com/products-MimicTurboGT.html)** | VU19P | Commercial Desktop prototyping solution |
| **ICT NP19A** | VU19P | Custom card with NVMe SSD support and expanded FPGA resources |

## Compatibility Matrix

| Board | VCU128 | Alveo U280 | NM37 | MimicTurbo GT | NP19A |
|-------|--------|------------|------|---------------|-------|
| Board string | vcu128 | au280 | nm37_vu37p | mimic_turbo | np19a_vu19p |
| **Features** | | | | | |
| M.2 Interface | × | × | ✓ | × | ✓ |
| RJ45 Interface | ✓ | × | ✓ | ✓ | ✓ |
| PCIe Card Format | Non-standard | ✓ | ✓ | ✓ | ✓ |
| DDR4 | 4.5GB | 32GB | 32GB | 16GB | 32GB |
| **CPU Support** | | | | | |
| Single-Core Nanhu-G | ✓ | ✓ | ✓ | ✓ | ✓ |
| Dual-Core Nanhu-G | × | × | × | ✓ | ✓ |
| Quad-Core Nanhu-G | × | × | × | ✓ | ✓ |
| Octa-Core Rocket-H | Testing | Testing | ✓ | ✓ | ✓ |
| Single-Core Kunminghu | × | × | × | ✓ | ✓ |

## Quick Start

### Prerequisites

- Ubuntu 20.04/22.04
- AMD/Xilinx Vivado 2024.2 Toolchain

### Initial Setup

```bash
# Clone and initialize submodules
git submodule update --init --recursive

# Create workspace structure
mkdir -p work_farm/target/
cd work_farm/target && ln -s ../../nanhu-g nanhu-g
cd ../ && ln -s ../shell shell
ln -s ../tools/ tools

# Install dependencies
sudo apt-get install openjdk-11-jdk device-tree-compiler gcc-riscv64-linux-gnu linux-headers-$(uname -r)

# Install Mill build tool
curl -L https://repo1.maven.org/maven2/com/lihaoyi/mill-dist/1.1.0-RC1/mill-dist-1.1.0-RC1-mill.sh -o mill
chmod +x mill && sudo mv mill /usr/local/bin
```

### Environment Configuration

```bash
export VIVADO_TOOL_BASE=/path/to/your/vivado  # e.g., /opt/Vivado_2024.2
export FPGA_BD=your_board_string  # vcu128, au280, nm37_vu37p, mimic_turbo, np19a_vu19p
export NUM_CORES=<1|2|4> # Number of Nanhu-G cores in the system
```

### Hardware Generation

#### Generate Nanhu-G Core

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

# Generate bitstream
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} FPGA_ACT=bit_gen vivado_prj
```

*Generated bitstream: `nanhu-g/ready_for_download/proto_${FPGA_BD}/system.bit`*

### Software Compilation

#### Boot ROM (ZSBL)

```bash
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} ARCH=riscv zsbl
```

#### Linux Boot Image

```bash
# Generate device tree
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} DT_TARGET=xiangshan target_dt

# Compile Linux kernel
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} ARCH=riscv phy_os.os

# Build OpenSBI boot image
make PRJ="target:nanhu-g:proto" FPGA_BD=${FPGA_BD} ARCH=riscv DT_TARGET=xiangshan opensbi
```

*Boot images: `nanhu-g/ready_for_download/proto_${FPGA_BD}/`*

### FPGA Deployment

#### Setup Hardware

- Install FPGA board in PCIe slot
- Ensure proper power supply
- Install AMD/Xilinx Vivado tools

#### Load XDMA Driver

```bash
make PRJ="shell:${FPGA_BD}" xdma_drv
cd shell/software/build/xdma_drv && sudo insmod xdma.ko
```

#### Run Evaluation

```bash
# Program FPGA with Vivado

# Then load and run (exit with CTRL+\)
cd tools/proto
sudo ./load_and_run.sh xdma<N> bootrom.bin RV_BOOT.bin

# For serial console only (exit with CTRL+\)
sudo ./load_and_run.sh xdma<N>
```

## Output Locations

- **Bitstream & Boot Images**: `nanhu-g/ready_for_download/proto_${FPGA_BD}/`
- **Vivado Projects**: `work_farm/fpga/vivado_prj/`
- **Build Reports**: `work_farm/fpga/vivado_out/`
- **XDMA Driver**: `shell/software/build/xdma_drv/`
