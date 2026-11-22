# October

This typst template and Python script generates a monthly calendar with photos.

## Usage

Before building for a new year, adjust easter dates and any other holiday changes
in `data/holidays.toml`.

The `fonts` directory should contain the Josefin Sans variable-size ttf file.

For SRA4 print, photos should have resolution 3660x2616 for roughly 12dpmm (~300dpi)
using the default bleed of 4mm. If splitting into two portraits, each portrait should
be 1830x2616. Scaling is handled by the script using magick; you only need to crop all
photos to the ratio 305:218. This is best done using darktable where the whole photo
library can be exported at once.

Save the cropped photos into a directory of your choice, named from `0.jpg` (title page)
up to `12.jpg` (December). If splitting into two portraits, name the photos, e.g.,
`1l.jpg` and `1r.jpg`. The script handles merging the two portraits into `1.jpg` which
is what typst expects.

The script is run by `gen.py --photos /path/to/photos --out calendar.pdf`. Adjust
`--names`, `--holidays`, `--lang`, and `--year` as appropriate, defaults are Slovak
and the upcoming year.

## License

[MIT No Attribution](LICENSE). Created without AI.
