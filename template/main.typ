#import "@local/preamble:0.1.0": *

// `paper` or `skript`; see preamble/README.md for all options.
#show: paper.with(
  title: [Title],
  authors: ((name: "Name", email: "example"),),
  abstract: [Abstract.],
)

= Introduction

Text.

// #show: appendix.with(bib: bibliography("works.yml"))
