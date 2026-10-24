# Toddler ABCs

A tiny Roku channel for toddlers: press any remote button to see the next letter, its picture, and hear "A. A is for Apple." Left (or rewind) goes back. Wraps Z to A and A to Z. Back is swallowed so little hands can't exit; Home still does.

## Sideload

1. On the Roku, enable developer mode: Home x3, Up x2, Right, Left, Right, Left, Right. Set a web password.
2. Build the package: `zip -r abc.zip manifest words.json source components images sounds`
    - `Compress-Archive -Path manifest, words.json, source, components, images, sounds -DestinationPath abc.zip`
3. Open `http://<roku-ip>` in a browser, log in as `rokudev`, upload `abc.zip`, click Install.

## Your own voice

Record each letter as 16-bit mono PCM WAV (22.05 or 44.1 kHz) and overwrite `sounds/a.wav` ... `sounds/z.wav` with the same filenames. Re-zip.

## Regenerating assets

`npm pack @twemoji/svg`, extract it, then `python3 tools/gen_assets.py <extracted>/package`. Needs espeak-ng, ffmpeg, rsvg-convert and Pillow. To change words, edit `words.json` (used by both the channel and the script).

## Attribution

Pictures are [Twemoji](https://github.com/jdecked/twemoji) graphics, copyright Twitter, Inc and other contributors, licensed under [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/). Speech is synthesized with eSpeak NG.
