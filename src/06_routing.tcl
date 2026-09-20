# =============================================================
# 06_routing.tcl
# =============================================================

puts "=== ROUTING ==="

route_opt
check_routes
save_lib

report_timing > "./reports/timing_routed.rpt"
report_drc    > "./reports/drc.rpt"
puts "=== ROUTING COMPLETE ==="
