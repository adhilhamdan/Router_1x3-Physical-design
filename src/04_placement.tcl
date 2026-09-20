# =============================================================
# 04_placement.tcl
# =============================================================

puts "=== PLACEMENT ==="

place_opt
legalize_placement
check_placement -verbose
save_lib

report_timing   > "./reports/timing_placed.rpt"
report_placement > "./reports/placement.rpt"
puts "=== PLACEMENT COMPLETE ==="
