# Architecture and development flow

The author describes C and MATLAB as **pre-RTL validation prototypes** used before the Verilog implementation. The hardware overview below is reconstructed from the supplied final RTL and the author's original block diagram. It is a functional view, not a cycle-accurate timing diagram.

## Development flow

1. Explore the image-processing algorithm in C and MATLAB.
2. Check coefficient quantization and intermediate arithmetic for an RTL implementation.
3. Develop Verilog submodules, stimulus testbenches, and custom behavioral RAM models for ModelSim simulation.
4. Use Vivado RAM IP blocks for the FPGA implementation and integrate camera capture, frame buffering, processing, and LCD output.

The archive records this sequence; it does not establish automated equivalence between every prototype and the final design.

## RAM in simulation and on the FPGA

This was an individual project undertaken during the author's fourth undergraduate year. The author wrote behavioral RAM models for ModelSim and used Vivado-provided RAM blocks when implementing the design on the FPGA.

The simulation RAM sources and the Vivado RAM IP belong to different implementation stages. The archived behavioral models have version-specific interfaces and dimensions; the original Vivado IP configuration is not included in the supplied archives. Reproduction should restore the appropriate RAM for the selected simulation or FPGA source set.

## Hardware data path

| Stage | Source/module | Interface and role |
|---|---|---|
| Camera capture | `rtl/CIS_IF.v` / `CIS_IF` | Camera `CY[7:0]` is assembled into RGB565; a 17-bit pixel address accompanies it |
| Packing | `rtl/packing.v` / `packing` | Two 16-bit pixels form a 32-bit memory word |
| Shared memory access | `rtl/packing_unpakcing.v` / `packing_unpacking` | Selects packing or unpacking word addresses according to `UP_CLK` |
| Frame storage | `bufferram` instance in `rtl/top.v` | 32-bit memory interface with 16-bit addresses; Vivado RAM IP was used for FPGA implementation, but its original configuration is not archived |
| Unpacking | `rtl/Unpacking.v` / `Unpacking` | Returns 16-bit pixels from 32-bit words |
| Color conversion | `rtl/R_2_Y.v` / `RGB_to_YCbCr` | RGB565 expands by zero-filling to 8-bit channels; output is `{Y, Cb, Cr}` |
| Line storage | `rtl/filtering.v` / `process` | Uses 48-bit line pairs plus the current pixel to form a 72-bit vertical stack |
| Neighborhood/filter | `rtl/conv.v` / `conv` | Three horizontal registers form a 3 × 3 neighborhood; only Y is enhanced |
| Output conversion | `rtl/Y_2_R.v` / `YCbCr_to_RGB` | Converts and clips back to RGB565 |
| Display output | `rtl/BRAMCtrl.v`, `rtl/TFTLCDCtrl.v` | Generates read addresses and drives R/G/B outputs with display timing |

`packing_unpakcing.v` retains the original filename spelling. Its module is named `packing_unpacking`.

## Data dimensions

- Display target: 480 × 272 = 130,560 pixels.
- RGB565 frame payload: 261,120 bytes.
- Packed frame payload: 65,280 words of 32 bits.
- The original diagram's intended frame buffer is 65,536 × 32 bits, consistent with a 16-bit word address. This describes the intended capacity; no RAM IP configuration was supplied.
- Two full lines of 24-bit YCbCr require 480 × 48 = 23,040 bits of payload storage. The archived `line_ram.v` simulation snapshot has a different capacity; the hardware design used Vivado RAM IP.

## Arithmetic

The forward transform uses coefficients scaled by 64. The intended coefficient magnitudes in the RTL are:

| Channel | R | G | B | Offset in scaled units |
|---|---:|---:|---:|---:|
| Y | 19 | 37 | 7 | 0 |
| Cb | −10 | −21 | 32 | 8192 |
| Cr | 32 | −26 | −5 | 8192 |

The reverse transform uses magnitudes 89, 22, 45, and 113 at the same scale. This table describes the intended arithmetic; signed-width behavior must be checked in simulation before asserting numerical equivalence.

The enhancement path forms a four-neighbor Laplacian response around the center Y sample, clips the response, adds half of it to the original center luminance, and clips again. Chroma comes from the center sample. `conv.v` uses explicit bit checks for clipping; these need boundary-value verification across the complete arithmetic range.

## Timing and control

- `g2m`, `horizontal`, and `vertical` generate display timing. The `g2m` logic divides its input clock by four; its historical divide-by-two comment is inconsistent with the implementation.
- `BRAMCtrl` generates the display read address from line and horizontal counts.
- `i2c_top` and `i2cset` sequence camera register programming through an `I2C` interface. The author confirms that the I²C controller is a reused implementation; its original provider is unspecified.
- The final design uses generated/inverted clocks and samples camera data in the host-clock domain. Clock-domain behavior and timing constraints require review before hardware reuse.
- `TFTLCDCtrl` drives `DE_out` high. Its internal active-region enables are separate signals; the block diagram does not imply that `DE_out` is a reconstructed active-video pulse.

## Diagram files

- [block_diagram_en.svg](images/block_diagram_en.svg): vector figure with editable text.
- [block_diagram_en.png](images/block_diagram_en.png): raster preview for presentations and GitHub.
- [render_block_diagram.py](../tools/render_block_diagram.py): Matplotlib source for the SVG.

The original diagram was redrawn with English labels and a separate offline development strip. The published figure is based on supplied RTL, not on a recovered synthesis netlist.
