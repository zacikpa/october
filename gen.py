import argparse
import os
import subprocess
import tempfile
from datetime import datetime
from pathlib import Path

DEFAULT_LANG = "sk"
DEFAULT_YEAR = datetime.now().year + 1
DEFAULT_HOLIDAYS = "SK"
DEFAULT_NAMES = "SK"
DEFAULT_PHOTOS = Path("./photos")
DEFAULT_OUTFILE = Path("./out.pdf")

def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--lang",
        type=str,
        default=DEFAULT_LANG,
        help="ISO 639 language code (e.g., en, cs, de).",
    )
    parser.add_argument(
        "--year",
        type=int,
        default=DEFAULT_YEAR,
        help="Target year as an integer (e.g., 2026).",
    )
    parser.add_argument(
        "--holidays",
        type=str.upper,
        default=DEFAULT_HOLIDAYS,
        help="ISO 3166-1 alpha-2 region code for holidays (e.g., CZ, US).",
    )
    parser.add_argument(
        "--names",
        type=str.upper,
        default=DEFAULT_NAMES,
        help="ISO 3166-1 alpha-2 region code for names (e.g., CZ, US).",
    )
    parser.add_argument(
        "--photos",
        type=Path,
        default=DEFAULT_PHOTOS,
        help="Path to the photos directory.",
    )
    parser.add_argument(
        "--out",
        type=Path,
        default=DEFAULT_OUTFILE,
        help="Path to the output calendar file",
    )
    args = parser.parse_args()
    
    tmp = tempfile.mkdtemp()

    for key in range(13):
        left = os.path.join(args.photos, f"{str(key)}l.jpg")
        right = os.path.join(args.photos, f"{str(key)}r.jpg")
        whole = os.path.join(args.photos, f"{str(key)}.jpg")

        if not os.path.isfile(left) or not os.path.isfile(right):
            continue
        tmp_left = os.path.join(tmp, "left.jpg")
        tmp_right = os.path.join(tmp, "right.jpg")

        subprocess.check_output(["magick", left, "-resize", "x2616", tmp_left])
        subprocess.check_output(["magick", right, "-resize", "x2616", tmp_right])
        subprocess.check_output(["magick", tmp_left, tmp_right, "+append", whole])

    subprocess.check_output([
        "typst", "compile", "main.typ",
        "--font-path=fonts",
        "--input", f"photos={args.photos}",
        "--input", f"year={str(args.year)}",
        "--input", f"lang={args.lang}",
        "--input", f"holidays={args.holidays}",
        "--input", f"names={args.names}",
        args.out
    ])

if __name__ == "__main__":
    main()
