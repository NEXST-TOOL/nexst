# synthesizing full design
synth_design -top xiangshan_wrapper -part ${device} \
    -directive default -flatten_hierarchy rebuilt

# PCIe RP GT physical location
#reset_property LOC [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gtye4_channel_inst[7].GTYE4_CHANNEL_PRIM_INST}]
#reset_property LOC [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gtye4_channel_inst[6].GTYE4_CHANNEL_PRIM_INST}]
#reset_property LOC [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gtye4_channel_inst[5].GTYE4_CHANNEL_PRIM_INST}]
#reset_property LOC [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gtye4_channel_inst[4].GTYE4_CHANNEL_PRIM_INST}]
reset_property LOC [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST}]
reset_property LOC [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST}]
reset_property LOC [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST}]
reset_property LOC [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]
#reset_property LOC [get_ports {pcie_rp_perstn[0]}]

#set_property LOC GTYE4_CHANNEL_X0Y7 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gtye4_channel_inst[7].GTYE4_CHANNEL_PRIM_INST}]
#set_property LOC GTYE4_CHANNEL_X0Y6 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gtye4_channel_inst[6].GTYE4_CHANNEL_PRIM_INST}]
#set_property LOC GTYE4_CHANNEL_X0Y5 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gtye4_channel_inst[5].GTYE4_CHANNEL_PRIM_INST}]
#set_property LOC GTYE4_CHANNEL_X0Y4 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gtye4_channel_inst[4].GTYE4_CHANNEL_PRIM_INST}]

# pcie 0 -> FMC DP5
set_property LOC GTYE4_CHANNEL_X0Y5 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gtye4_channel_inst[3].GTYE4_CHANNEL_PRIM_INST}]
# pcie 1 -> FMC DP6
set_property LOC GTYE4_CHANNEL_X0Y6 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gtye4_channel_inst[2].GTYE4_CHANNEL_PRIM_INST}]
# pcie 2 -> FMC DP4
set_property LOC GTYE4_CHANNEL_X0Y4 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gtye4_channel_inst[1].GTYE4_CHANNEL_PRIM_INST}]
# pcie 3 -> FMC DP7
set_property LOC GTYE4_CHANNEL_X0Y7 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[0].*gen_gtye4_channel_inst[0].GTYE4_CHANNEL_PRIM_INST}]
# pcie 7 -> FMC DP0; perstn
#set_property LOC GTYE4_CHANNEL_X0Y0 [get_ports {pcie_rp_perstn[0]}]


# setup output logs and reports
report_timing_summary -file ${synth_rpt_dir}/synth_timing.rpt -delay_type max -max_paths 1000

# setup output logs and reports
report_utilization -hierarchical -file ${synth_rpt_dir}/synth_util_hier.rpt
report_utilization -file ${synth_rpt_dir}/synth_util.rpt
    
# write checkpoint
write_checkpoint -force ${dcp_dir}/synth.dcp

