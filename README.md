# preamble

My Typst setup for papers and lecture notes, as a local package.

## Install (once per machine)

```powershell
./install.ps1
```

This links this folder to `%APPDATA%\typst\packages\local\preamble\<version>`, so edits here apply to every document straight away. Re-run it after moving the folder or bumping the version.

## Use

```typst
#import "@local/preamble:0.1.0": *

#show: paper.with(        // or skript.with(...), or project.with(style: "paper", ...)
  title: [My Title],
  authors: ((name: "Name", email: "example"),),
  abstract: [...],
)
```

To start a new document from a template: `typst init @local/preamble:0.1.0 my-doc`.

Any normal set rule after the `#show:` line overrides the template, e.g. `#set par(first-line-indent: 0pt)`.

## Options

Options marked *preset* default to `auto` and take the value of the chosen style.

| option | paper | skript | meaning |
|---|---|---|---|
| `title`, `subtitle` | | | |
| `authors` | | | `"Name"`, `(name:, email:, department:, organization:, location:, url:)` or an array of these |
| `date` | today | today | datetime, content, or `none` |
| `abstract` | | | paper only |
| `draft` | `false` | | `true`, or a URL where the latest version lives |
| `show-title` | `true` | `true` | title block / title page |
| `toc` *preset* | `true` | `true` | table of contents after the title |
| `lang` *preset* | `"en"` | `"de"` | also switches "Proof"/"Beweis", "Theorem"/"Satz", ... |
| `font` *preset* | New Computer Modern | Libertinus Serif | |
| `sans-font` *preset* | Noto Sans | Noto Sans | skript headings and bold text |
| `font-size` *preset* | 11pt | 11pt | title sizes scale with it |
| `paper-size` | `"a4"` | `"a4"` | |
| `margin` *preset* | 3.2cm | 3cm | length or `(x: ..., y: ...)` |
| `page-lines` *preset* | `true` | `false` | crop-mark decorations |
| `heading-numbering` | `"1.1"` | `"1.1"` | |
| `equation-numbering` *preset* | `"(1)"` | `none` | only labelled equations get a number |
| `report-style` | | `false` | skript: level-1 headings as "Kapitel 1." |
| `colors` | | | override single colours, e.g. `(accent: maroon)`; see `presets` in `src/project.typ` |

## What else is exported

- `appendix`: `#show: appendix.with(bib: bibliography("works.yml"))` prints the bibliography and switches headings to A.1
- Theorem boxes (blue, one shared counter): `theorem`, `proposition`, `new-theorem("Lemma")` for more, `t-no-num[Name][...]` for named unnumbered ones
- `example`, `cool-box("Title")[...]`, `exercise[Aufgabe 1][...]`
- `proof[...]`, `proof(of: <label>)[...]`, `proof(title: [...])[...]`
- Napkin-style boxes: `blue_box`, `brown_box`, `plain_box`, `green_note`, `black_note`, `green_box`
- `note[...]`: margin note
- `prose[@key]`: citation in running text; `blkm`, `redm`: black or red text, e.g. inside coloured equations

## CI

`.github/workflows/render.yml` copies this folder into the runner's local package directory before compiling. If the package moves to its own repo, check that repo out there instead.
