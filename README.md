# jekyll-highlight-rgbasm

A Jekyll plugin using Rouge to highlight RGBASM Game Boy assembly
language.

Check it out at https://martendo.github.io/jekyll-highlight-rgbasm!

## Usage

Since GitHub Pages doesn't build sites with "unsupported plugins", it's
necessary to build using something else, such as GitHub Actions. The
Action used to build this project's site is at
[`.github/workflows/build.yml`](/.github/workflows/build.yml), which can
be used as an example.

The plugin itself is at [`_plugins/rgbasm.rb`](/_plugins/rgbasm.rb). Put
that file in your Jekyll site's `_plugins` directory (just like it is
for this project's site) and any `rgbasm` code blocks will be
highlighted!

````markdown
```rgbasm
ld a, [hli]
ld h, [hl]
ld l, a
```
````

### Outside of Jekyll

The Jekyll plugin doesn't contain anything other than a Rouge lexer for
the RGBASM language. It could be used directly with Rouge outside of
Jekyll, but I don't know how or why that should be done. It's probably
possible if you want to, though!
