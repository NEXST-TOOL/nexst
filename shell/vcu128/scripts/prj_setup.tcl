# add custom_cpu source HDL files
add_files -fileset sources_1 ${design_dir}/../fpga/sources/hdl/

# setup block design
set bd_design xiangshan
source ${design_dir}/../fpga/scripts/${bd_design}.tcl
close_bd_design ${bd_design}

set bd_file_gen_loc \
    ./${vivado_prj_name}/${vivado_prj_name}.srcs/sources_1/bd
set bd_file_gen \
    ./${bd_file_gen_loc}/${bd_design}/${bd_design}.bd

# generate wrapper for xiangshan
make_wrapper -files [get_files ${bd_file_gen}] -top
exec cp -r ./${vivado_prj_name}/${vivado_prj_name}.gen/sources_1/bd/${bd_design} \
    ${bd_file_gen_loc}/
import_files -force -norecurse -fileset sources_1 \
    ./${bd_file_gen_loc}/${bd_design}/hdl/${bd_design}_wrapper.v

set_property synth_checkpoint_mode None [get_files ${bd_file_gen}]
generate_target all [get_files ${bd_file_gen}]

# setup top module
set_property top ${bd_design}_wrapper [get_filesets sources_1]

# add constraints files
set main_constraints ${design_dir}/../fpga/constraints/top.xdc
add_files -fileset constrs_1 -norecurse ${main_constraints}
