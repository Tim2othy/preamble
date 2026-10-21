// Boxes in the style of Evan Chen's Napkin, taken from https://github.com/napkin-community/solutions
// Usage: #blue_box(subtitle: [optional])[Lemma 1][content]
#import "colors.typ": palette

#let latexize(content) = [
  #show math.equation: set text(features: ("cv01",))
  #set par(spacing: 0.8em, justify: true)
  #content
]

#let titlize(title, subtitle) = if subtitle != none [*#title* (#subtitle)] else [*#title*]
#let titlize_dot(title, subtitle) = if subtitle != none [*#title* (#subtitle)*.*] else [*#title.*]

// Brown box, used for examples.
#let brown_box(title, content, subtitle: none) = block(
  width: 100%,
  stroke: 1pt + palette.napkin-brown,
  fill: palette.napkin-brown-fill,
  radius: 0.5em,
  inset: 1em,
  latexize[
    #text(fill: palette.napkin-brown, titlize(title, subtitle))

    #content
  ],
)

// Note with a black left strip, used for questions and exercises.
#let black_note(title, content, subtitle: none) = block(
  width: 100%,
  stroke: (left: 3pt + black),
  fill: palette.napkin-grey-fill,
  inset: (left: 1em, right: 1em, y: 1em),
  latexize[
    #titlize_dot(title, subtitle)
    #content
  ],
)

// Note with a green left strip, used for remarks.
#let green_note(title, content, subtitle: none) = block(
  width: 100%,
  stroke: (left: 3pt + palette.napkin-green),
  fill: palette.napkin-green-fill,
  inset: (left: 3pt + 1em, right: 1em, y: 1em),
  latexize[
    #text(fill: palette.napkin-green)[#titlize(title, subtitle) #sym.dash.em]
    #content
  ],
)

// Green box, used for results of remarks.
#let green_box(content) = block(
  width: 100%,
  stroke: 1pt + palette.napkin-green-frame,
  inset: (x: 1em, y: 0.65em),
  latexize[#text(fill: palette.napkin-green, [*#content*])],
)

// Blue box, used for theorems, lemmas, corollaries and propositions.
#let blue_box(title, content, subtitle: none) = block(
  width: 100%,
  stroke: 1pt + palette.classic-theorem,
  fill: palette.classic-fill,
  radius: 0.5em,
  inset: 1em,
  latexize[
    #text(fill: palette.teal, titlize(title, subtitle))

    #content
  ],
)

// Plain box, used for definitions, problems and simple quotes.
#let plain_box(content, title: none, subtitle: none) = block(
  width: 100%,
  stroke: 1pt + black,
  inset: (x: 1em, y: 0.65em),
  latexize(if title == none { content } else [#titlize_dot(title, subtitle) #content]),
)
