// Words the templates print themselves, per language. Unknown languages fall back to English.
#let strings = (
  en: (
    theorem: "Theorem",
    proposition: "Proposition",
    example: "Example",
    proof: "Proof",
    proof-of: "Proof of",
    contents: "Contents",
    abstract: "Abstract",
    references: "References",
    appendix: "Appendix",
    chapter: "Chapter",
    and-word: "and",
    draft: url => [Draft. #if url != none [See #emph(link(url)[here]) for latest version.]],
  ),
  de: (
    theorem: "Satz",
    proposition: "Proposition",
    example: "Beispiel",
    proof: "Beweis",
    proof-of: "Beweis von",
    contents: "Inhaltsverzeichnis",
    abstract: "Zusammenfassung",
    references: "Literatur",
    appendix: "Anhang",
    chapter: "Kapitel",
    and-word: "und",
    draft: url => [Entwurf. #if url != none [Die aktuelle Version gibt es #emph(link(url)[hier]).]],
  ),
)

// Looks up `key` for the current text language. Function entries are called with `args`.
#let tr(key, ..args) = context {
  let value = strings.at(text.lang, default: strings.en).at(key)
  if type(value) == function { value(..args) } else { value }
}
