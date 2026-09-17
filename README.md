# FPGA Camera-to-LCD Image Processing

A Verilog project for a **480 × 272 camera-to-LCD image-processing pipeline**, with RGB565 frame buffering, fixed-point RGB–YCbCr conversion, and luminance enhancement.

**Development workflow:** C and MATLAB were used first to check the algorithms and fixed-point arithmetic before implementing the design in Verilog. They are pre-RTL validation prototypes, rather than software stages executed in the FPGA data path.

**Reused component:** camera configuration reuses an existing I²C controller. See [source notes](docs/SOURCE_NOTES.md) for attribution and dependency details.

[한국어](README_KO.md) · [Architecture](docs/ARCHITECTURE.md) · [Build status](docs/BUILD_STATUS.md) · [Development history](archive/README.md)

![English block diagram of the FPGA camera-to-LCD image-processing pipeline](docs/images/block_diagram_en.svg)

[Download the diagram as SVG](docs/images/block_diagram_en.svg) · [PNG](docs/images/block_diagram_en.png)

## What the design explores

- Capture an 8-bit camera stream and assemble 16-bit RGB565 pixels.
- Pack two pixels into each 32-bit frame-memory word, then unpack them for display.
- Convert RGB565 to 24-bit YCbCr using fixed-point coefficients.
- Build a 3 × 3 neighborhood using line storage and horizontal registers.
- Enhance the luminance channel with a Laplacian response, a gain term, and clipping; retain the center pixel's chroma.
- Convert the result to RGB565 and generate the LCD timing and read addresses.

## Start here

| Location | Contents |
|---|---|
| [`rtl/`](rtl) | Integrated Verilog design from `DE_final_project.zip` |
| [`constraints/top.xdc`](constraints/top.xdc) | Supplied pin constraints; verify against the actual board before use |
| [`sim/original/`](sim/original) | Original stimulus testbenches, retained for reference |
| [`reference/c/`](reference/c) | Floating-point and fixed-point C prototypes used before RTL development |
| [`reference/matlab/`](reference/matlab) | Pre-RTL calculations, image processing, and test-vector preparation |
| [`tools/bmp2coe_legacy/`](tools/bmp2coe_legacy) | Original Windows C++ BMP-to-COE utility |
| [`archive/`](archive) | Earlier RTL iterations and historical memory models |
| [`docs/`](docs) | Architecture, setup notes, and original-to-release file mapping |

Begin with [`rtl/top.v`](rtl/top.v), then [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the module map. The final RTL is separated from historical alternatives because many versions define modules with the same names.

## Current build status

This repository preserves the supplied implementation and its development history. It is **not yet a complete, independently verified FPGA build**: the supplied final source set needs the `bufferram` implementation, a compatible `line_ram`, and the implementation behind the `I2C` interface. Some historical testbenches also have interface mismatches. See the concrete findings and restoration steps in [`docs/BUILD_STATUS.md`](docs/BUILD_STATUS.md).

No HDL simulation, FPGA synthesis, board test, or C/MATLAB numerical equivalence run was performed during this packaging work. No FPS, timing closure, resource utilization, or image-quality result is claimed.

## Working with the pre-RTL prototypes

- **C:** the original code uses Windows bitmap types and `fopen_s`. Use a Windows C toolchain and review the hard-coded input/output filenames. The floating-point and fixed-point folders are separate prototypes.
- **MATLAB:** scripts document intermediate calculations and experiments. Some require image-processing functions; GPU experiments use `gpuArray`. Run only the script relevant to the experiment after supplying its inputs.
- **BMP-to-COE:** the original converter emits RGB888 hexadecimal words. It does not directly produce packed RGB565 frame-memory words.

These prototypes are not asserted to be bit-exact golden models of the final RTL. Known script and arithmetic differences are recorded in the build notes.

## How the archive was organized

Source filenames and implementation logic were retained. Text was normalized to UTF-8 and LF where needed. The filtering design repeated in `RGB_YCbCr_total.zip` is identical to the final project's source set and maps to the same release files.

Generated IDE/build/simulator files, sample photographs and their derived image data, and compiled netlists are kept in the original input archives rather than this source release. [`docs/source_manifest.csv`](docs/source_manifest.csv) records every original file, its hash, the release destination or exclusion reason, and the release hash.

See [`docs/SOURCE_NOTES.md`](docs/SOURCE_NOTES.md) for dependency provenance and license status.
