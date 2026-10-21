// The document templates. Use one of
//   #show: paper.with(title: [...], authors: ("Me",))
//   #show: skript.with(title: [...])
//   #show: project.with(style: "paper", ...)
// Every option left at `auto` takes its value from the style's preset below.
// Anything else can be overridden with ordinary set rules after the `#show:` line.
#import "@preview/equate:0.3.2": equate
#import "@preview/marginalia:0.2.3" as marginalia
#import "page-lines.typ": downlines, uplines
#import "strings.typ": tr
#import "environments.typ": theorem-rules

#let presets = (
  // AMS-article like: centered title block, running header, run-in bold paragraphs
  paper: (
    lang: "en",
    font: ("New Computer Modern", "Libertinus Serif"),
    sans-font: "Noto Sans",
    font-size: 11pt,
    margin: 3.2cm,
    page-lines: true,
    toc: true,
    equation-numbering: "(1)",
    date-format: "[day].[month].[year]",
    colors: (accent: rgb("#19197f"), link: rgb("006896")),
  ),
  // Lecture notes: title page with table of contents, sans-serif headings with "§1.1"
  skript: (
    lang: "de",
    font: "Libertinus Serif",
    sans-font: "Noto Sans",
    font-size: 11pt,
    margin: 3cm,
    page-lines: false,
    toc: true,
    equation-numbering: none,
    date-format: "[day] [month repr:long] [year]",
    colors: (title: eastern, headers: maroon, theorem: rgb("006896"), link: blue),
  ),
)

// Accepts "Name", (name: "Name", email: ..., ...) or an array of these.
#let _normalize-authors(authors) = {
  if authors == none { return () }
  if type(authors) != array { authors = (authors,) }
  authors.map(a => if type(a) == dictionary { a } else { (name: a) })
}

#let _paper(cfg, body) = {
  let scale = cfg.font-size / 11pt
  let script-size = 9pt * scale
  let large-size = 14pt * scale
  let title-size = 16pt * scale
  let accent = cfg.colors.accent

  set page(
    // Odd pages show the title, even pages the authors; nothing on page 1.
    header-ascent: 14pt,
    header: context {
      let i = counter(page).get().first()
      if cfg.page-lines { uplines(cfg.margin-x) }
      if i > 1 {
        set text(size: script-size)
        let running = if calc.odd(i) { cfg.title } else { cfg.author-string }
        grid(
          columns: (6em, 1fr, 6em),
          align: (start, center, end),
          [], if running != none { upper(running) }, [#i],
        )
      }
    },
    // On the first page the footer shows the page number.
    footer-descent: 12pt,
    footer: context {
      let i = counter(page).get().first()
      if i == 1 { align(center, [#i]) }
      if cfg.page-lines { downlines(cfg.margin-x) }
    },
  )

  // Headings
  show heading: set text(accent)
  show heading: set block(above: 1.7em, below: 1em)
  show heading: it => {
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      h(7pt, weak: true)
    }
    set text(weight: 500)
    v(25pt, weak: true)
    number
    it.body
    h(7pt, weak: true)
  }

  set list(indent: 1em)
  set enum(indent: 1em)

  // Bold text works as a run-in paragraph heading: *Related Literature.* Text...
  show strong: it => text(accent, it) + h(1em)

  show math.equation: set block(below: 8pt, above: 9pt)
  show math.equation: set text(accent)

  set figure(placement: top)
  show selector.or(table, image): pad.with(x: 23pt)

  // Title block
  if cfg.show-title {
    v(35pt, weak: true)
    align(center, {
      text(size: title-size, weight: 700, accent, cfg.title)
      if cfg.subtitle != none {
        v(15pt, weak: true)
        text(size: large-size, cfg.subtitle)
      }
      if cfg.author-string != none {
        v(25pt, weak: true)
        text(size: large-size, cfg.author-string)
      }
      if cfg.date != none {
        v(10pt, weak: true)
        text(size: script-size, cfg.date)
      }
      if cfg.draft != false {
        v(10pt, weak: true)
        text(size: script-size, tr("draft", if type(cfg.draft) == str { cfg.draft }))
      }
    })
  }

  set par(justify: true, spacing: 1.25em, first-line-indent: 1.5em, leading: 0.85em)

  if cfg.abstract != none {
    v(20pt, weak: true)
    set text(script-size)
    show: pad.with(x: 35pt)
    smallcaps[#tr("abstract"). ]
    cfg.abstract
  }

  show link: set text(fill: cfg.colors.link)
  show: theorem-rules

  v(29pt, weak: true)
  if cfg.toc {
    outline()
    pagebreak()
  }

  body

  // Author details at the end
  v(12pt, weak: true)
  show: pad.with(x: 11.5pt)
  set par(first-line-indent: 0pt)
  set text(script-size)
  for author in cfg.authors {
    let keys = ("department", "organization", "location")
    smallcaps(keys.filter(key => key in author).map(key => author.at(key)).join(", "))
    linebreak()
    if "email" in author [
      _Email address:_ #link("mailto:" + author.email) \
    ]
    if "url" in author [
      _URL:_ #link(author.url)
    ]
    v(12pt, weak: true)
  }
}

#let _skript(cfg, body) = {
  let colors = cfg.colors

  // Figure captions: bold "Figure 1" and indented
  show figure.caption: cap => context {
    set text(0.95em)
    block(inset: (x: 5em), [
      #set align(left)
      #text(weight: "bold")[#cap.supplement #cap.counter.display(cap.numbering)]#cap.separator#cap.body
    ])
  }

  // Tables: bold header row, horizontal rules only, striped rows
  show figure.where(kind: table): fig => {
    show table.cell.where(y: 0): set text(weight: "bold")
    let tableframe(stroke) = (x, y) => (
      left: 0pt,
      right: 0pt,
      top: if y <= 1 { stroke } else { 0pt },
      bottom: stroke,
    )
    set table(
      stroke: tableframe(rgb("#21222c")),
      fill: (_, y) => if (y == 0) { rgb("#ffeeff") } else if calc.even(y) { rgb("#eaf2f5") },
    )
    fig
  }

  set page(
    // Title and author on the right, except on the title page
    header: context {
      if cfg.page-lines { uplines(cfg.margin-x) }
      set align(right)
      set text(size: 0.8em)
      if not cfg.show-title or counter(page).get().first() > 1 {
        text(weight: "bold", cfg.title)
        if cfg.author-string != none {
          h(0.2em)
          sym.dash.em
          h(0.2em)
          text(style: "italic", cfg.author-string)
        }
      }
    },
    numbering: "1",
    ..if cfg.page-lines {
      (footer: context {
        align(center, counter(page).display())
        downlines(cfg.margin-x)
      })
    },
  )
  set par(justify: true)

  show strong: set text(font: cfg.sans-font, size: 0.9em)

  set quote(block: true)
  show quote: set pad(x: 2em, y: 0em)
  show quote: it => {
    set text(style: "italic")
    v(-1em)
    it
    v(-0.5em)
  }

  set enum(numbering: "(a)", spacing: 1.2em, indent: 1.4em)
  set list(spacing: 1.2em, indent: 1.4em)

  // Headings: "§1.1 Title", or "Chapter 1. Title" for level 1 with `report-style`
  show heading: it => {
    block([
      #if (it.numbering != none) [
        #text(
          fill: colors.headers,
          (if (cfg.report-style and it.level == 1) [#tr("chapter") ] else { "§" })
            + counter(heading).display()
            + (if (cfg.report-style and it.level == 1) { "." } else { "" }),
        )
        #h(0.2em)
      ]
      #it.body
      #v(0.4em)
    ])
  }
  show heading: set text(font: cfg.sans-font, size: cfg.font-size)
  show heading.where(level: 1): set text(size: cfg.font-size * 14 / 11)
  show heading.where(level: 2): set text(size: cfg.font-size * 12 / 11)

  // Internal links get the theorem colour, external ones the link colour
  show link: it => {
    set text(fill: if type(it.dest) == label { colors.theorem } else { colors.link })
    it
  }
  show ref: it => if it.element == none { it } else { link(it.target, it) }
  show ref: it => {
    let el = it.element
    // References to plain blocks (e.g. the Napkin boxes) have no number to show
    if el != none and el.func() == block { return link(el.location(), "(todo: fix this)") }
    if el != none and el.func() == heading and el.level == 1 and it.supplement == auto and cfg.report-style {
      ref(it.target, supplement: tr("chapter"))
    } else {
      it
    }
  }
  show: theorem-rules

  // Title page with table of contents
  if cfg.show-title {
    v(2.5em)
    set align(center)
    set block(spacing: 2em)
    block(text(fill: colors.title, size: 2em, font: cfg.sans-font, weight: "bold", cfg.title))
    if cfg.subtitle != none {
      text(size: 1.5em, font: cfg.sans-font)[\- #cfg.subtitle -]
    }
    if cfg.author-string != none {
      block(smallcaps(text(size: 1.7em, cfg.author-string)))
    }
    if cfg.date != none {
      block(text(size: 1.2em, cfg.date))
    }
    v(1.5em)
  }
  if cfg.toc {
    v(1fr)
    show outline.entry.where(level: 1): it => {
      v(1.6em)
      text(weight: "bold", font: cfg.sans-font, it)
    }
    show outline.entry.where(level: 2): it => {
      v(0.9em, weak: true)
      text(size: 0.9em, font: cfg.sans-font, it)
    }
    text(fill: colors.title, size: 1.4em, font: cfg.sans-font, tr("contents"))
    v(0.1em)
    outline(title: none, indent: 2em)
    v(1fr)
  }
  if cfg.show-title or cfg.toc {
    pagebreak()
  }

  body
}

#let _styles = (paper: _paper, skript: _skript)

#let project(
  // "paper" or "skript"; decides the look and the defaults of all `auto` options.
  style: "paper",
  title: none,
  subtitle: none,
  // A name, (name: ..., email: ..., department: ..., organization: ..., location: ..., url: ...) or an array of these.
  authors: (),
  // A datetime, any content, or none to hide it.
  date: datetime.today(),
  abstract: none,
  // true, or a URL string where the latest version lives.
  draft: false,
  // Show the title block (paper) or title page (skript).
  show-title: true,
  // Table of contents after the title.
  toc: auto,
  lang: auto,
  font: auto,
  // Used for headings and bold text in the skript.
  sans-font: auto,
  font-size: auto,
  paper-size: "a4",
  // A length, or (x: ..., y: ...).
  margin: auto,
  // Crop-mark style decorations around the text area.
  page-lines: auto,
  heading-numbering: "1.1",
  // Only labelled equations get a number. none turns numbering off.
  equation-numbering: auto,
  // skript: level-1 headings become "Chapter 1." instead of "§1".
  report-style: false,
  // Overrides single colours of the preset, e.g. (accent: maroon).
  colors: (:),
  body,
) = {
  assert(style in _styles, message: "style must be one of " + _styles.keys().join(", "))
  let preset = presets.at(style)
  let pick(value, key) = if value == auto { preset.at(key) } else { value }

  let authors = _normalize-authors(authors)
  let names = authors.map(a => a.name)
  let margin = pick(margin, "margin")
  let (margin-x, margin-y) = if type(margin) == dictionary { (margin.x, margin.y) } else { (margin, margin) }
  let cfg = (
    title: title,
    subtitle: subtitle,
    authors: authors,
    author-string: if names.len() == 2 { names.join([ #tr("and-word") ]) } else { names.join(", ", last: [, #tr("and-word") ]) },
    date: if type(date) == datetime { date.display(preset.date-format) } else { date },
    abstract: abstract,
    draft: draft,
    show-title: show-title,
    toc: pick(toc, "toc"),
    font-size: pick(font-size, "font-size"),
    sans-font: pick(sans-font, "sans-font"),
    margin-x: margin-x,
    page-lines: pick(page-lines, "page-lines"),
    report-style: report-style,
    colors: preset.colors + colors,
  )
  let equation-numbering = pick(equation-numbering, "equation-numbering")

  set document(title: title, author: names.filter(n => type(n) == str))
  set text(font: pick(font, "font"), size: cfg.font-size, lang: pick(lang, "lang"))
  set page(paper: paper-size, margin: (x: margin-x, y: margin-y))
  set heading(numbering: heading-numbering)

  set math.equation(numbering: equation-numbering) if equation-numbering != none
  show: if equation-numbering != none { equate.with(number-mode: "label") } else { it => it }

  // Margin notes (`#note[...]`) live in the outer 5/32 .. 29/32 of the side margins
  let far = 3 / 32 * margin-x
  let sep = 5 / 32 * margin-x
  show: marginalia.setup.with(
    outer: (far: far, width: margin-x - sep - far, sep: sep),
    inner: (far: far, width: margin-x - sep - far, sep: sep),
    top: margin-y,
    bottom: margin-y,
    clearance: 7mm,
  )

  _styles.at(style)(cfg, body)
}

#let paper = project.with(style: "paper")
#let skript = project.with(style: "skript")

// Starts the appendix: prints the bibliography (if given) and switches headings to "A.1".
//   #show: appendix.with(bib: bibliography("works.yml"))
#let appendix(bib: none, style: "harvard-cite-them-right", numbering: "A.1", body) = {
  if bib != none {
    set std.bibliography(style: style, title: tr("references"))
    show std.bibliography: set text(8.5em / 11)
    show std.bibliography: set block(above: 1.3em)
    bib
  }
  set heading(numbering: numbering, supplement: tr("appendix"))
  counter(heading).update(0)
  body
}
