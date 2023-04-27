# open shell checkpoint
open_checkpoint ${script_dir}/../shell/${board}/dcp/shell_region.dcp

# open role checkpoint
read_checkpoint -cell [get_cells xiangshan_i/u_role/inst] \
    ${dcp_dir}/synth.dcp

# Design optimization
opt_design

# Save debug probe file
write_debug_probes -force ${out_dir}/debug_nets.ltx

