# Source and packaging notes

## Inputs

Seven original ZIP archives were inspected. Their filenames, sizes, and SHA-256 hashes are in `input_archives.json`; individual file mappings are in `source_manifest.csv`.

The author also supplied a block-diagram image and clarified that the C and MATLAB code preceded the Verilog implementation as pre-RTL validation. The architecture documentation and redrawn diagram are based on the supplied RTL, that image, and this development context.

## Reused I²C component

The author explicitly confirms that the I²C controller was an existing implementation reused for camera configuration. It is credited here as a reused dependency. Its original provider, version, and redistribution terms are not identified in the supplied material. The integration files and interface are preserved with their existing notices.

## Source preservation

- Implementation logic and original source filenames are retained.
- Text sources were decoded as UTF-8 or CP949, then saved as UTF-8/LF. Korean comments already damaged in an original file are not reconstructed by guessing.
- Duplicate final sources were mapped to a single release copy.
- Final RTL, historical versions, original testbenches, and pre-RTL prototypes are separated by role.
- Newly written content consists of documentation and the English diagram-generation script.

## Excluded material

The original ZIPs retain IDE caches, compiled simulator libraries, debug/build files, wave databases, intermediate outputs, and sample images. The public candidate contains the sources needed for review, rather than these generated files.

Sample photographs (including files named `lena.bmp`), their converted COE files, and derived image outputs are omitted. The code still documents the original filenames; use your own suitable test image when restoring an experiment.

The compiled `I2C.ngc` binary is omitted because the corresponding implementation source and redistribution terms were not supplied. The `I2C.v` interface remains to document that dependency. This omission contributes to the incomplete board-build status.

## License status

No license was supplied for the combined project. No blanket MIT, Apache, or other license is assigned during packaging. Existing source notices are retained. The original authorship of teaching/vendor support modules and the I2C implementation has not been independently established.
