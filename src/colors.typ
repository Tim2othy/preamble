// Every colour the package uses, defined once. Everything else imports `palette` from here.
// Built-in colours (black, white, red, blue, maroon, eastern) are used by name.
#let palette = (
  // Theorem boxes, titled style: frame and title bar, the body is a light tint of it
  theorem: rgb("#2c62a3"),
  cool: rgb("#2e8540"),
  example: rgb("#9a6b12"),
  // Theorem boxes, classic style; also the Napkin blue box
  classic-fill: rgb("#f3fbfb"),
  classic-theorem: rgb("#0000ff"),
  // Classic theorem titles, internal links in the skript, links in the paper
  teal: rgb("#006896"),
  classic-cool: rgb("#36c369"),
  classic-cool-title: rgb("#2aa728"),
  classic-example: rgb("#ac7f1e"),
  classic-example-title: rgb("#a58c1d"),
  // Napkin boxes
  napkin-brown: rgb("#9e3c0e"),
  napkin-brown-fill: rgb("#fff9f8"),
  napkin-green: rgb("#008000"),
  napkin-green-fill: rgb("#f2f9f5"),
  napkin-green-frame: rgb("#00b200"),
  napkin-grey-fill: rgb("#fafafa"),
  // Exercises and margin notes
  exercise-fill: rgb("#eeeeee"),
  note-number: rgb("#e604b1"),
  note-fill: oklch(90%, 0.06, 140deg),
  // Paper
  paper-accent: rgb("#19197f"),
  // Skript tables
  table-frame: rgb("#21222c"),
  table-head: rgb("#ffeeff"),
  table-stripe: rgb("#eaf2f5"),
)
