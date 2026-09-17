# Development history

Earlier versions are preserved as separate snapshots. They are not additional files to include in the final RTL compilation: many snapshots declare identical module names.

| Directory | Role |
|---|---|
| `camera_lcd/` | Earlier camera capture, packing, and LCD integration |
| `color/RGB_YCbCr_converter_v1/` | Standalone color converters and their testbenches |
| `color/RGB_YCbCr_v1/` | Integrated color conversion before filtering was added |
| `packing/` | Packing/unpacking iterations, including v2–v9 and the YCbCr-integrated variant |
| `memory_models/` | Snapshots of author-written simulation RAM models; review version-specific interfaces and dimensions |

The author wrote RAM models for ModelSim simulation and used Vivado RAM IP blocks for the FPGA implementation. The RAM files here preserve simulation-stage snapshots. See the [RAM workflow and reproduction notes](../docs/BUILD_STATUS.md) for details.

Version names follow the supplied directories and do not imply that the highest-numbered folder is the final design. The integrated source set is selected from the explicitly supplied `DE_final_project.zip`.

The repeated `RGB_YCbCr_v2(filtering)` source set maps to `rtl/`, `constraints/`, `sim/original/`, and `archive/memory_models/`; it is not duplicated here. See the [source manifest](../docs/source_manifest.csv) for the mapping.
