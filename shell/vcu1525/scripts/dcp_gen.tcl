
source [file join $script_dir "prj_setup.tcl"]
add_files -fileset sources_1 ${design_dir}/../fpga/sources/hdl/

set bd_design ${prj_design}

source ${design_dir}/../fpga/scripts/${bd_design}.tcl

set bd_file_gen_loc \
    ./${vivado_prj_name}/${vivado_prj_name}.srcs/sources_1/bd

set bd_file_gen \
    ./${bd_file_gen_loc}/${bd_design}/${bd_design}.bd

set_property synth_checkpoint_mode None [get_files ${bd_file_gen}] 
generate_target all [get_files ${bd_file_gen}] 

# Using custom role wrapper instead of the auto-generated one
# make_wrapper -files [get_files ${bd_file_gen}] -top
# exec cp -r ./${vivado_prj_name}/${vivado_prj_name}.gen/sources_1/bd/${bd_design} \
    ${bd_file_gen_loc}/
# import_files -force -norecurse -fileset sources_1 \
    ./${bd_file_gen_loc}/${bd_design}/hdl/${bd_design}_wrapper.v

validate_bd_design
save_bd_design
close_bd_design ${bd_design}
	
# synthesizing design
synth_design -top ${bd_design}_wrapper -part ${device} -mode out_of_context
	
# write checkpoint
write_checkpoint -force ${dcp_dir}/${bd_design}.dcp
