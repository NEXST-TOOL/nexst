# open synthesis checkpoint
open_checkpoint ${dcp_dir}/synth.dcp

# Design optimization
opt_design

# Save debug probe file
write_debug_probes -force ${out_dir}/debug_nets.ltx

