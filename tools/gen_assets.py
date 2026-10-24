#!/usr/bin/env python3
"""Regenerate sounds/, images/ and icons. Usage: tools/gen_assets.py TWEMOJI_SVG_DIR
The SVG dir is the contents of `npm pack @twemoji/svg` (the extracted package/ folder).
Needs: apt-get install -y espeak-ng librsvg2-bin; ffmpeg; Pillow."""
import json, subprocess, sys
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
FONT = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"
WORDS = json.loads((ROOT / "words.json").read_text())

def run(*a):
    subprocess.run(a, check=True)

def icon(path, w, h):
    im = Image.new("RGB", (w, h), "#FFD23F")
    d = ImageDraw.Draw(im)
    cols = ["#EE4266", "#3BCEAC", "#0EAD69"]
    f = ImageFont.truetype(FONT, int(h * 0.6))
    total = d.textlength("ABC", font=f)
    x = (w - total) / 2
    for ch, c in zip("ABC", cols):
        d.text((x, h / 2), ch, font=f, fill=c, anchor="lm", stroke_width=max(2, h // 60), stroke_fill="white")
        x += d.textlength(ch, font=f)
    im.save(path)

def main(svg_dir):
    svg_dir = Path(svg_dir)
    for w in WORDS:
        l, word, cp = w["letter"].lower(), w["word"], w["emoji"]
        run("rsvg-convert", "-w", "512", "-h", "512", "-o", str(ROOT / f"images/{l}.png"), str(svg_dir / f"{cp}.svg"))
        # Comma stops espeak reading the 2nd "A" as the article "uh"; en-us says "zee" not "zed".
        # Check pronunciation without audio: espeak-ng -v en-us -q -x "<text>"
        text = f"{l.upper()}. {l.upper()}, is for {word}."
        run("espeak-ng", "-v", "en-us", "-s", "130", "-w", str(ROOT / f"sounds/_{l}.wav"), text)
        run("ffmpeg", "-y", "-loglevel", "error", "-i", str(ROOT / f"sounds/_{l}.wav"),
            "-af", "loudnorm=I=-16:TP=-1.5", "-ar", "22050", "-ac", "1", "-c:a", "pcm_s16le",
            str(ROOT / f"sounds/{l}.wav"))
        (ROOT / f"sounds/_{l}.wav").unlink()
    icon(ROOT / "images/icon_focus_fhd.png", 540, 405)
    icon(ROOT / "images/icon_focus_hd.png", 290, 218)
    icon(ROOT / "images/splash_fhd.png", 1920, 1080)

if __name__ == "__main__":
    main(sys.argv[1])
