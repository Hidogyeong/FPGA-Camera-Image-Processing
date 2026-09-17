# Build and verification status

## Original development context

The author completed this as an individual project during the fourth year of undergraduate study. As clarified by the author:

- C and MATLAB were used for checks before RTL implementation.
- Behavioral RAM models were written by the author for ModelSim simulation.
- Vivado-provided RAM IP blocks were used for the actual FPGA implementation.
- Camera configuration reused an existing I²C controller.

The original Vivado RAM IP configuration is not present in the supplied archives. The checks below describe the currently preserved files and what is needed to reproduce them today. The historical simulation models and the final hardware RAM IP belong to different development stages.

## What was checked during packaging

- Inventoried seven ZIP archives and mapped every file to a retained destination or an exclusion reason.
- Compared the filtering sources in `DE_final_project.zip` and `RGB_YCbCr_total.zip`: all 23 `.v`/`.xdc` files match byte for byte before normalization.
- Preserved source logic while converting decodable source text to UTF-8 and normalizing line endings.
- Inspected the final module hierarchy, memory interfaces, supplied testbenches, and C/MATLAB input assumptions.
- Checked retained source hashes and local Markdown links, and visually reviewed the newly rendered English diagram.

No new HDL simulation, Vivado build, MATLAB run, or Windows C execution was performed during archive preparation because the required tools were unavailable. The author's original ModelSim and FPGA workflow is recorded above; no new timing, board-performance, or cross-language numerical equivalence measurements are reported.

## Archive gaps and checks for reproduction

| Area | Finding in supplied files | Next step before execution |
|---|---|---|
| Frame RAM | `rtl/top.v` instantiates `bufferram`; the author used Vivado RAM IP for hardware, but its configuration is not archived | Recover or regenerate the Vivado RAM IP with the original dimensions, latency, and write mode |
| Line RAM | The final RTL uses `clka/wea/addra/dina/douta`. The archived simulation snapshot uses `clk/WEN/A/DI/DOUT`, has contradictory 96/48-bit output widths, and declares five entries. The original Vivado RAM configuration is not archived | For hardware, restore the Vivado RAM IP matching the 48-bit data path and intended depth. For simulation, select or adapt a model to the chosen RTL version |
| I2C | Reused controller, not authored by the project author; `rtl/I2C.v` is an empty interface and the original ZIP includes a compiled `I2C.ngc` | Recover the implementation and its provenance, or use an explicitly documented replacement |
| Packing stimulus | `sim/original/tb_packing_unpackin.v` uses reduced address widths | Align the testbench with the selected DUT or explicitly document truncation/extension |
| Processing stimulus | `sim/original/tb_process.v` observes 16 bits while the final output is 24 bits | Fix the testbench observation width before evaluating full YCbCr output |
| LCD stimulus | `sim/original/tb_TFTLCDCtrl.v` connects a nonexistent `data_en` port and a 16-bit BRAM input | Update against the final interface before compilation |
| Historical main RAM | `archive/memory_models/main_mem.v` declares `RAM[655365:0]` with a 16-bit address | Confirm the intended capacity and replace only in a documented restoration change |
| Timing | The supplied XDC lists pin/IOSTANDARD assignments but no `create_clock` constraints | Verify the actual board, clock source, generated clocks, and timing constraints |
| Arithmetic | Signed/unsigned coefficient widths and bit-based saturation require boundary checks | Compare RTL outputs to a separately validated reference over boundary and representative inputs |
| Camera sampling | Host-clock capture and generated clocks are present | Check the sensor clock relationship, synchronization, and board timing |

The author-written behavioral RAM snapshots are preserved in `archive/memory_models/` as part of the simulation development history. Their interfaces and dimensions should be checked against the selected RTL version when reproducing a simulation.

## C and MATLAB pre-validation notes

The prototypes were written before RTL development. They are useful evidence of the design process, but the supplied versions have differences that matter for reproduction:

- Both C `filtering.c` variants set `Phei = wid + AddSize`, rather than using the image height. Review padding and indexing before non-square-image experiments.
- C image loading tests `&fp == NULL` rather than `fp == NULL` and returns values from a `void` function. Review input handling before running.
- C uses Windows bitmap structures and `fopen_s`; the C++ converter also uses Windows headers.
- The BMP-to-COE converter writes 24-bit RGB words and assumes a simple BMP layout. Check row padding, pixel offset, and image orientation before reuse.
- `reference/matlab/tb_test.m` reads `Y_fd_gpu` without creating it in the active code; much of the filtering loop is commented out.
- `reference/matlab/gaussian_test.m` uses an enhancement gain of 0.8, whereas the final RTL adds half the clipped response.
- `reference/matlab/RGB565_to_YCbCr.m` is a scalar exploration and omits the +128 term in its Cr expression; it is not a complete golden model.
- MATLAB scripts refer to input images or text vectors that remain in the original archives. Image-processing and GPU functions can require additional MATLAB toolboxes.
- Original testbenches are stimulus-oriented and generally have no automatic pass/fail assertions. A successful compile alone would not establish correctness.

These findings are recorded without rewriting the historical implementations.

## Historical environment clues

The preliminary `Camera_LCD_ctrl_v1.xpr` records **Vivado 2021.2**, FPGA part **`xc7z020clg484-1`**, and board preset **`xilinx.com:zc702:part0:1.4`**. These are facts about that preliminary project file, not confirmation of the final physical board or pinout. The `.xpr` does not provide a complete final project. ModelSim artifacts are present in the source ZIPs, and the author confirms using ModelSim with custom RAM models. The exact historical source/testbench combination has not been re-executed during archive preparation.

## Suggested restoration order

1. Confirm the physical FPGA board, camera module, LCD panel, clock rates, and tool versions.
2. Restore the Vivado RAM IP configuration for hardware, select compatible RAM models for simulation, and recover the reused I2C dependency; verify interfaces and latencies.
3. Compile the final source set independently of historical alternatives.
4. Update the original testbenches and add meaningful arithmetic, pixel-order, and frame-boundary checks.
5. Run full synthesis/implementation with verified pin and clock constraints.
6. Record board observations and reproducible results before adding performance claims.
