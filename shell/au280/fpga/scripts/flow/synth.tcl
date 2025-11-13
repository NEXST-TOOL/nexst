# # synthesizing full design
# synth_design -top xiangshan_wrapper -part ${device} \
#     -directive default -flatten_hierarchy rebuilt

# # PCIe RP GT physical location
# reset_property LOC [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST}]
# reset_property LOC [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST}]
# reset_property LOC [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST}]
# reset_property LOC [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]
# set_property LOC GTYE4_CHANNEL_X0Y12 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST}]
# set_property LOC GTYE4_CHANNEL_X0Y13 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST}]
# set_property LOC GTYE4_CHANNEL_X0Y14 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST}]
# set_property LOC GTYE4_CHANNEL_X0Y15 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[3].*gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]

# # setup output logs and reports
# report_timing_summary -file ${synth_rpt_dir}/synth_timing.rpt -delay_type max -max_paths 1000

# # setup output logs and reports
# report_utilization -hierarchical -file ${synth_rpt_dir}/synth_util_hier.rpt
# report_utilization -file ${synth_rpt_dir}/synth_util.rpt
    
# # write checkpoint
# write_checkpoint -force ${dcp_dir}/synth.dcp


# synthesizing full design
synth_design -top xiangshan_wrapper -part ${device} \
    -directive default -flatten_hierarchy rebuilt

# setup output logs and reports
report_timing_summary -file ${synth_rpt_dir}/synth_timing.rpt -delay_type max -max_paths 1000

# setup output logs and reports
report_utilization -hierarchical -file ${synth_rpt_dir}/synth_util_hier.rpt
report_utilization -file ${synth_rpt_dir}/synth_util.rpt
    
# write checkpoint
write_checkpoint -force ${dcp_dir}/synth.dcp

