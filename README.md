# Router_1x3-Physical-design

A 1x3 asynchronous router datapath and control logic designed for an ASIC physical design flow, including synthesis, floorplanning, placement, clock tree synthesis, routing, and signoff.

## Domain
VLSI Physical Design / ASIC Implementation

## Tools & Technologies
- Verilog HDL
- Synopsys Fusion Compiler / Design Compiler style flow
- Tcl-based physical design automation
- SAED 32nm PDK
- Synthesis, floorplan, placement, CTS, routing, and signoff scripts

## Project Overview
This project implements a 1x3 router RTL and a complete backend physical design flow around it. The design contains a packet-based finite-state machine, register logic, address decoding, FIFO storage, parity checking, and output-valid generation for three downstream channels. The RTL is organized into separate modules for the top-level router, state machine, synchronization logic, registers, and FIFO buffers.

The physical design scripts (`01_setup.tcl` through `07_signoff.tcl`) automate the full flow for a target clock period, including design setup, generic mapping, floorplanning, placement, clock tree synthesis, routing, and signoff checks such as timing, area, DRC, and power reporting. The project demonstrates a realistic ASIC implementation path for an RTL design into a manufacturable physical layout target.

## Folder Structure
```
Router_1x3-Physical-design/
├── src/                        # RTL and physical design scripts
│   ├── 01_setup.tcl            # PDK/library setup and design configuration
│   ├── 02_synthesis.tcl        # RTL read, elaboration, mapping, and synthesis reports
│   ├── 03_floorplan.tcl        # Core creation and power ring/stripe setup
│   ├── 04_placement.tcl        # Placement optimization and legalization
│   ├── 05_cts.tcl              # Clock tree synthesis and timing checks
│   ├── 06_routing.tcl          # Route optimization and DRC verification
│   ├── 07_signoff.tcl          # Timing/power/area signoff and final outputs
│   ├── router_top.v            # Top-level 1x3 router module
│   ├── router_fsm.v            # FSM for packet processing and control logic
│   ├── router_reg.v            # Register logic, parity, error detection, and packet handling
│   ├── router_sync.v           # Address latch, FIFO write enable, and output validity control
│   ├── router_fifo.v           # 16x8 FIFO implementation for each output channel
│   └── run_all.tcl             # Script to run the full PD flow
├── docs/                       # (reserved for documentation)
├── reports/                    # generated timing, area, DRC, and placement reports
└── results/                    # (reserved for final design outputs and waveforms)
```

## How to Run
1. Open a Synopsys Fusion Compiler environment or equivalent physical design toolchain.
2. Run the full flow from the project root:
   ```
   fc_shell -f src/run_all.tcl |& tee pd_run.log
   ```
3. The flow executes the setup, synthesis, floorplan, placement, CTS, routing, and signoff stages in sequence.
4. Review the generated reports in `reports/` and the final netlist/layout artifacts from the signoff stage.

## Author
Adhil Hamdan | adhil30072003@gmail.com