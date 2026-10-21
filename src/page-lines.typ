// Crop-mark style decorations in the page corners and edges ("page lines").
// Both functions are meant to be placed in the page header/footer and need context.
#import "@preview/cetz:0.4.2"

#let clen = 0.9
#let cgap = 0.4

#let corner = cetz.canvas({
  import cetz.draw: *
  set-style(stroke: 0.2pt)
  line((-cgap - clen, 0.0), (-cgap, 0.0))
  line((0.0, cgap), (0.0, cgap + clen))
})

#let cross = cetz.canvas({
  import cetz.draw: *
  set-style(stroke: 0.2pt)
  line((-clen, 0.0), (clen, 0.0))
  line((0.0, -clen / 2), (0.0, clen / 2))
  circle((0.0, 0.0), radius: clen / 4)
})

#let uplines(margin-x) = {
  let corner-distance = margin-x / 3
  place(top + right, dx: margin-x - corner-distance, dy: corner-distance, rotate(corner, 90deg))
  place(top + left, dx: -margin-x + corner-distance, dy: corner-distance, corner)
  place(top + center, dy: corner-distance, cross)
}

#let downlines(margin-x) = {
  let corner-distance = margin-x / 3
  place(bottom + right, dx: margin-x - corner-distance, dy: -corner-distance, rotate(corner, 180deg))
  place(bottom + left, dx: -margin-x + corner-distance, dy: -corner-distance, rotate(corner, 270deg))
  place(bottom + center, dy: -corner-distance, cross)
  // Crosses half way down the left and right page edges
  let distance = page.height - 2 * (corner-distance + (clen / 2 + cgap) * 1cm + 0.45cm)
  let pos-y = -corner-distance - (clen / 2 + cgap) * 1cm - distance / 2
  let pos-x = margin-x - corner-distance + 0.5 * 0.9cm
  place(bottom + left, dx: -pos-x, dy: pos-y, rotate(cross, 90deg))
  place(bottom + right, dx: pos-x, dy: pos-y, rotate(cross, 90deg))
}
