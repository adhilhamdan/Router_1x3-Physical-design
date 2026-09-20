# =============================================================
# 03_floorplan.tcl
# =============================================================

puts "=== FLOORPLAN ==="

initialize_floorplan \
    -utilization_ratio 0.7 \
    -aspect_ratio      1.0 \
    -core_offset       2.0

create_rectangular_rings \
    -nets    {VDD VSS} \
    -width   2.0 \
    -spacing 0.5

create_power_stripes \
    -nets    {VDD VSS} \
    -layer   M5 \
    -width   1.0 \
    -pitch   10.0

synthesize_power_rails
save_lib

report_floorplan > "./reports/floorplan.rpt"
puts "=== FLOORPLAN COMPLETE ==="
