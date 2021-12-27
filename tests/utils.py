from pathlib import Path

# __file__ manipulations are fine here, because tests are not distributed
WARP_ROOT = Path(__file__).parents[1]
CAIRO_PATH = WARP_ROOT / "src" / "warp" / "cairo-src"
