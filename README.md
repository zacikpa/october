# October

This template generates a monthly calendar, designed to be printed in landscape.

## Usage

Before building for a new year, adjust easter dates and any other holiday changes
in `data/holidays.toml`.

Then adjust `main.typ` with photo directory containing files named `0.jpg` (title)
up to `12.jpg` (december), and choose language, holiday country and name day country.

Build with `typst compile main.typ --font-path=fonts` where
the `fonts` directory contains the Josefin Sans variable-size ttf file.

## License

[MIT No Attribution](LICENSE). Created without AI.
