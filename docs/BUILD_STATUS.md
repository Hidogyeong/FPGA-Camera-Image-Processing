# Build and verification status

## What was checked during packaging

- Inventoried seven ZIP archives and mapped every file to a retained destination or an exclusion reason.
- Compared the filtering sources in `DE_final_project.zip` and `RGB_YCbCr_total.zip`: all 23 `.v`/`.xdc` files match byte for byte before normalization.
- Preserved source logic while converting decodable source text to UTF-8 and normalizing line endings.
- Inspected the final module hierarchy, memory interfaces, supplied testbenches, and C/MATLAB input assumptions.
- Checked retained source hashes and local Markdown links, and visually reviewed the newly rendered English diagram.

No HDL simulator, Vivado, MATLAB, or Windows C toolchain was available for an original-project execution. No synthesis, timing closure, FPGA board run, or cross-language numerical equivalence result is claimed here.

## Concrete restoration items

| Area | Finding in supplied files | Next step before execution |
|---|---|---|
| Frame RAM | `rtl/top.v` instantiates `bufferram`, but no matching source or IP configuration was supplied | Restore the actual RAM IP and its latency/write mode; do not silently substitute a guessed RAM |
| Line RAM | `process` uses `clka/wea/addra/dina/douta`; the supplied historical model declares `clk/WEN/A/DI/DOUT`, contradictory 96/48-bit output widths, and only five entries | Restore the final line-buffer IP/model matching the 48-bit data path and intended depth |
| I2C | Reused controller, not authored by the project author; `rtl/I2C.v` is an empty interface and the original ZIP includes a compiled `I2C.ngc` | Recover the implementation and its provenance, or use an explicitly documented replacement |
| Packing stimulus | `sim/original/tb_packing_unpackin.v` uses reduced address widths | Align the testbench with the selected DUT or explicitly document truncation/extension |
| Processing stimulus | `sim/original/tb_process.v` observes 16 bits while the final output is 24 bits | Fix the testbench observation width before evaluating full YCbCr output |
| LCD stimulus | `sim/original/tb_TFTLCDCtrl.v` connects a nonexistent `data_en` port and a 16-bit BRAM input | Update against the final interface before compilation |
| Historical main RAM | `archive/memory_models/main_mem.v` declares `RAM[655365:0]` with a 16-bit address | Confirm the intended capacity and replace only in a documented restoration change |
| Timing | The supplied XDC lists pin/IOSTANDARD assignments but no `create_clock` constraints | Verify the actual board, clock source, generated clocks, and timing constraints |
| Arithmetic | Signed/unsigned coefficient widths and bit-based saturation require boundary checks | Compare RTL outputs to a separately validated reference over boundary and representative inputs |
| Camera sampling | Host-clock capture and generated clocks are present | Check the sensor clock relationship, synchronization, and board timing |

The memory model files are kept in `archive/memory_models/` to prevent them from looking like verified drop-in replacements for the missing final IP.

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

The preliminary `Camera_LCD_ctrl_v1.xpr` records **Vivado 2021.2**, FPGA part **`xc7z020clg484-1`**, and board preset **`xilinx.com:zc702:part0:1.4`**. These are facts about that preliminary project file, not confirmation of the final physical board or pinout. The `.xpr` does not provide a complete final project. ModelSim artifacts are present in the source ZIPs; their presence does not prove that the retained final source set passes simulation.

## Suggested restoration order

1. Confirm the physical FPGA board, camera module, LCD panel, clock rates, and tool versions.
2. Restore the memory and I2C implementations, then verify their interfaces and latencies.
3. Compile the final source set independently of historical alternatives.
4. Update the original testbenches and add meaningful arithmetic, pixel-order, and frame-boundary checks.
5. Run full synthesis/implementation with verified pin and clock constraints.
6. Record board observations and reproducible results before adding performance claims.
