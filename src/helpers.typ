// Small helpers for writing.

// Citation in running text: #prose[@jones2024] -> "Jones (2024)"
#let prose(citation) = {
  set cite(form: "prose")
  citation
}

// Black or red text, e.g. inside equations that are coloured by the template.
#let blkm(body) = text(fill: black, body)
#let redm(body) = text(fill: red, body)
