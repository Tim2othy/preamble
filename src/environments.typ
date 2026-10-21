// Theorem-like environments, proofs, exercises and margin notes.
#import "@preview/ctheorems:1.1.3": thmcounters, thmenv, thmrules
#import "@preview/marginalia:0.2.3" as marginalia
#import "strings.typ": tr

#let theorem-color = rgb("006896")

// "titled": coloured title bar on top. "classic": light box with the title running into the text.
// Set for a whole document with `paper.with(box-style: ...)`, or per box with `#theorem(style: "classic")[...]`.
#let box-style = state("preamble-box-style", "titled")

// Box whose top and bottom edges are separate blocks, so a box split across pages
// stays open at the page break instead of being closed on both pages.
// Needs context (for the page colour).
#let _frame(color, fill, header, body, radius: 4pt, inset: 1em) = {
  let stroke = 1pt + color
  let top = if header == none {
    block(width: 100%, height: radius, fill: fill, stroke: (top: stroke, x: stroke), radius: (top: radius))
  } else {
    block(width: 100%, fill: color, stroke: stroke, radius: (top: radius), inset: (x: inset, y: 0.5em), header)
  }
  // The bottom edge overlaps the last `radius` of the body, so it always fits on the body's last page.
  // Its corners are first painted in the page colour to hide the body's square corners.
  let background = if type(page.fill) == std.color { page.fill } else { white }
  let bottom = block(width: 100%, height: radius, {
    place(dx: -stroke.thickness, rect(width: 100% + 2 * stroke.thickness, height: 100%, fill: background))
    place(rect(width: 100%, height: 100%, fill: fill, stroke: (bottom: stroke, x: stroke), radius: (bottom: radius)))
  })
  let pad-y = if header == none { inset - radius } else { inset * 0.8 }
  pad(y: 0.5em, {
    block(sticky: true, above: 0pt, below: 0pt, top)
    block(
      breakable: true,
      above: 0pt,
      below: 0pt,
      width: 100%,
      fill: fill,
      stroke: (x: stroke),
      inset: (x: inset, top: pad-y, bottom: pad-y + radius),
      body,
    )
    v(-radius)
    block(above: 0pt, below: 0pt, bottom)
  })
}

// A ctheorems environment drawn with `_frame`.
//   head: "Theorem", or "" for boxes that only show their name
//   color: frame and title bar of the titled style
//   classic: colours of the classic style; `bold` makes its "Theorem 3" bold,
//   `name-fmt` formats the name, e.g. "(Name)"
#let _box(identifier, head, color, classic: (:), bold: true, name-fmt: x => [(#x)], numbered: true) = {
  let classic = (stroke: color, fill: rgb("f3fbfb"), title: color) + classic
  let fmt(name, number, body, style: auto) = context {
    let style = if style == auto { box-style.get() } else { style }
    let title = if number == none { head } else [#head #number]
    if style == "titled" {
      let header = (if head != "" { title }, name).filter(x => x != none).join[: ]
      _frame(color, color.lighten(94%), text(fill: white, weight: "bold", header), body)
    } else {
      let title = text(fill: classic.title, if bold { strong(title) } else { title })
      let name = if name == none { [] } else [ #text(fill: classic.title, name-fmt(name))]
      _frame(classic.stroke, classic.fill, none, [#title#name#h(0.1em):#h(0.2em)#body], radius: 0.3em, inset: 1.2em)
    }
  }
  let env = thmenv(identifier, "heading", 0, fmt).with(supplement: head)
  if numbered { env } else { env.with(numbering: none) }
}

// Numbered box. All boxes made with this share one counter.
// `bold` makes the "Theorem 3" part of the classic title bold.
#let new-theorem(head, bold: true) = _box(
  "theorem", head, rgb("#2c62a3"),
  classic: (stroke: rgb("0000ff"), title: theorem-color),
  bold: bold,
)

#let theorem = new-theorem(tr("theorem"))
#let proposition = new-theorem(tr("proposition"), bold: false)

// Box that shows only its name, e.g. a named theorem: #t-no-num[Satz von Bolzano-Weierstraß][...]
#let t-no-num = _box(
  "theorem", "", rgb("#2c62a3"),
  classic: (stroke: rgb("0000ff"), title: theorem-color),
  name-fmt: strong, numbered: false,
)

// Green box with a title, e.g. #cool-box("Parameters")[...]
#let cool-box = _box(
  "Parameters", "", rgb("#2e8540"),
  classic: (stroke: rgb("#36c369"), title: rgb("#2aa728")),
  name-fmt: x => x, numbered: false,
)

#let example = _box(
  "Example", tr("example"), rgb("#9a6b12"),
  classic: (stroke: rgb("#ac7f1e"), title: rgb("#a58c1d")),
  bold: false, numbered: false,
)

// Show rules for the boxes above. `project` applies them already.
// References to an unnumbered box show its name, numbered ones show e.g. "Satz 3".
#let theorem-rules(body) = {
  show: thmrules.with(qed-symbol: $square$)
  show ref: it => {
    if it.element == none or it.element.func() != figure or it.element.kind != "thmenv" {
      return it
    }
    let supplement = it.element.supplement
    if it.citation.supplement != none {
      supplement = it.citation.supplement
    }
    if it.element.numbering == none {
      return link(it.target, it.element.caption.body)
    }
    let thms = query(selector(<meta:thmenvcounter>).after(it.element.location()))
    let number = thmcounters.at(thms.first().location()).at("latest")
    link(it.target, [#supplement~#numbering(it.element.numbering, ..number)])
  }
  body
}

// Proof with a square at the end.
//   #proof[...]                 -> "Proof. ..."
//   #proof(of: <thm-label>)[...] -> "Proof of Theorem 3. ..."
//   #proof(title: [Idea])[...]  -> "Idea. ..."
#let proof(of: none, title: auto, qed: $square$, body) = {
  if title == auto {
    title = if of == none { tr("proof") } else [#tr("proof-of") #ref(of)]
  }
  block(width: 100%, breakable: true)[#emph[#title.] #body#h(1fr)#qed]
}

// Grey box for exercises: #exercise[Aufgabe 2][...]
#let exercise(title, body) = pad(
  x: 0.5em,
  y: 0.6em,
  block(width: 100%, breakable: true, fill: rgb("#eeeeee"), outset: 0.9em)[#strong(title) \ #body],
)

// Margin note, numbered A, B, C, ...
#let note = marginalia.note.with(
  numbering: (..i) => text(weight: 500, size: 8pt, fill: rgb("#e604b1"), numbering("A", ..i)),
  block-style: (
    fill: oklch(90%, 0.06, 140deg),
    outset: (left: 10pt, rest: 4pt),
    radius: 4pt,
  ),
  text-style: (font: "Fira Sans", size: 8pt),
)
