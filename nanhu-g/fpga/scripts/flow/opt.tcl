# open shell checkpoint
open_checkpoint ${dcp_dir}/../../shell_${board}_${board}/dcp/synth.dcp

# read floorplan constraint
read_xdc ${dcp_dir}/../../../../shell/${board}/fpga/constraints/floorplan.xdc

# open role checkpoint
read_checkpoint -cell [get_cells xiangshan_i/u_role/inst] \
    ${dcp_dir}/synth.dcp

# Design optimization
opt_design

# Save debug probe file
write_debug_probes -force ${out_dir}/debug_nets.ltx

