# =============================================================
# 05_cts.tcl
# =============================================================

puts "=== CTS ==="

set_clock_tree_options \
    -target_skew    0.1 \
    -target_latency 0.5

clock_opt
set_propagated_clock [all_clocks]
save_lib

report_clock_tree        > "./reports/cts.rpt"
report_timing -delay max > "./reports/timing_cts_setup.rpt"
report_timing -delay min > "./reports/timing_cts_hold.rpt"
puts "=== CTS COMPLETE ==="
