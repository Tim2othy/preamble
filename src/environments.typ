// Theorem-like environments, proofs, exercises and margin notes.
#import "@preview/ctheorems:1.1.3": thmbox, thmcounters, thmrules
#import "@preview/marginalia:0.2.3" as marginalia
#import "strings.typ": tr

#let theorem-color = rgb("006896")

// Light blue numbered box. All boxes made with this share one counter.
// `bold` makes the "Theorem 3" part of the title bold.
#let new-theorem(head, bold: true) = thmbox(
  "theorem",
  head,
  fill: rgb("f3fbfb"),
  stroke: 1pt + rgb("0000ff"),
  breakable: true,
  base_level: 0,
  namefmt: x => text(fill: theorem-color)[(#x)],
  titlefmt: x => text(fill: theorem-color, if bold { strong(x) } else { x }),
)

#let theorem = new-theorem(tr("theorem"))
#let proposition = new-theorem(tr("proposition"), bold: false)

// Theorem box that shows only its name, e.g. a named theorem: #t-no-num[Satz von Bolzano-Weierstraß][...]
#let t-no-num = thmbox(
  "theorem",
  "",
  fill: rgb("f3fbfb"),
  stroke: 1pt + rgb("0000ff"),
  breakable: true,
  base_level: 0,
  namefmt: x => strong(text(fill: theorem-color, x)),
).with(numbering: none)

// Green box with a title, e.g. #cool-box("Parameters")[...]
#let cool-box = thmbox(
  "Parameters",
  "Parameters",
  fill: rgb("f3fbfb"),
  stroke: 1pt + rgb("#36c369"),
  breakable: true,
  base_level: 0,
  namefmt: x => text(fill: rgb("#2aa728"))[#x],
  titlefmt: x => text(fill: rgb("#2aa728"), ""),
).with(numbering: none)

#let example = thmbox(
  "Example",
  tr("example"),
  fill: rgb("f3fbfb"),
  stroke: 1pt + rgb("#ac7f1e"),
  breakable: true,
  base_level: 0,
  namefmt: x => text(fill: rgb("#a58c1d"))[(#x)],
  titlefmt: x => text(fill: rgb("#a58c1d"), x),
).with(numbering: none)

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
