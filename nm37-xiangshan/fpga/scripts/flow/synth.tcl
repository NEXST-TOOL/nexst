# synthesizing full design
synth_design -top role_top -part ${device} -mode out_of_context

# setup output logs and reports
report_timing_summary -file ${synth_rpt_dir}/synth_timing.rpt -delay_type max -max_paths 1000

# setup output logs and reports
report_utilization -hierarchical -file ${synth_rpt_dir}/synth_util_hier.rpt
report_utilization -file ${synth_rpt_dir}/synth_util.rpt
    
# write checkpoint
write_checkpoint -force ${dcp_dir}/synth.dcp

