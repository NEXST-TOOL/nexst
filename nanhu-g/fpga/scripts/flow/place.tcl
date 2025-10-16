# open checkpoint of the opt_design phase
# open_checkpoint ${dcp_dir}/opt_pass_3.dcp

# Placement with SSI logic spreading strategy for congestion avoidance 
place_design -directive SSI_BalanceSLRs

report_utilization -file ${impl_rpt_dir}/post_place_util.rpt
report_timing_summary -file ${impl_rpt_dir}/post_place_timing_setup.rpt -delay_type max -max_paths 1000
report_timing_summary -file ${impl_rpt_dir}/post_place_timing_hold.rpt -delay_type min -max_paths 1000

write_checkpoint -force ${dcp_dir}/place.dcp

# Physical design optimization
## Conducting the following passes if setup time constraints are violated
## Pass 1: logic replication
phys_opt_design -directive AlternateReplication

report_utilization -file ${impl_rpt_dir}/post_place_phys_opt_alt_replica_util.rpt
report_timing_summary -file ${impl_rpt_dir}/post_place_phys_opt_alt_replica_timing_setup.rpt -delay_type max -max_paths 1000

write_checkpoint -force ${dcp_dir}/post_place_phys_opt_alt_replica.dcp

## Pass 2: Aggressive fan-out optimization
phys_opt_design -directive AggressiveFanoutOpt

report_utilization -file ${impl_rpt_dir}/post_place_phys_opt_aggressive_fanout_opt_util.rpt
report_timing_summary -file ${impl_rpt_dir}/post_place_phys_opt_aggressive_fanout_opt_timing_setup.rpt -delay_type max -max_paths 1000

write_checkpoint -force ${dcp_dir}/post_place_phys_opt_aggressive_fanout_opt.dcp

## Pass 3: Retiming 
phys_opt_design -directive AddRetime

report_utilization -file ${impl_rpt_dir}/post_place_phys_opt_retiming_util.rpt
report_timing_summary -file ${impl_rpt_dir}/post_place_phys_opt_retiming_timing_setup.rpt -delay_type max -max_paths 1000

write_checkpoint -force ${dcp_dir}/post_place_phys_opt_retiming.dcp

## Conducting the following passes if hold time constraints are violated
## Pass 4: Explore strategy with hold fixing
phys_opt_design -directive AggressiveExplore

report_utilization -file ${impl_rpt_dir}/post_place_phys_opt_aggressive_explore_util.rpt
report_timing_summary -file ${impl_rpt_dir}/post_place_phys_opt_aggressive_explore_timing_setup.rpt -delay_type max -max_paths 1000
report_timing_summary -file ${impl_rpt_dir}/post_place_phys_opt_aggressive_explore_timing_hold.rpt -delay_type min -max_paths 1000

write_checkpoint -force ${dcp_dir}/post_place_phys_opt_aggressive_explore.dcp

## Pass 5: Explore strategy with hold fixing
phys_opt_design -directive ExploreWithAggressiveHoldFix

report_utilization -file ${impl_rpt_dir}/post_place_phys_opt_aggressive_hold_fix_util.rpt
report_timing_summary -file ${impl_rpt_dir}/post_place_phys_opt_aggressive_hold_fix_timing_setup.rpt -delay_type max -max_paths 1000
report_timing_summary -file ${impl_rpt_dir}/post_place_phys_opt_aggressive_hold_fix_timing_hold.rpt -delay_type min -max_paths 1000
		
write_checkpoint -force ${dcp_dir}/post_place_phys_opt_aggressive_hold_fix.dcp

