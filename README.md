# October

This template generates a monthly calendar, designed to be printed in landscape.

## Usage

Before building for a new year, adjust easter dates and any other holiday changes
in `data/holidays.toml`.

Then adjust `main.typ` with photo directory containing files named `0.jpg` (title)
up to `12.jpg` (december), and choose language, holiday country and name day country.

For SRA4 print, photos should have resolution 3050x2180 for roughly 10dpmm (~300dpi)
using the default bleed of 4mm. If splitting into two portraits, each portrait should
be 1525x2180. In GIMP, first crop each image to the desired ratio (305:218 or 305:436),
then scale to the desired resolution. It's also useful to toggle
the `View > Snap to Canvas Edges` when working in GIMP.

Build with `typst compile main.typ --font-path=fonts` where
the `fonts` directory contains the Josefin Sans variable-size ttf file.

## License

[MIT No Attribution](LICENSE). Created without AI.
