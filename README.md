# jekyll-highlight-rgbasm

A Jekyll plugin using Rouge to highlight RGBASM Game Boy assembly
language.

Check it out at https://martendo.github.io/jekyll-highlight-rgbasm!

## Usage

Since GitHub Pages doesn't build sites with "unsupported plugins", it's
necessary to build using something else, such as GitHub Actions. The
Action used to build this project's site is at
[`.github/workflows/build.yml`](.github/workflows/build.yml), which can
be used as an example.

The plugin is at [`_plugins/rgbasm.rb`](/_plugins/rgbasm.rb). Put that
file in your Jekyll site's `_plugins` directory and any `rgbasm` code
blocks will be highlighted!

````markdown
```rgbasm
ld a, [hli]
ld h, [hl]
ld l, a
```
````
