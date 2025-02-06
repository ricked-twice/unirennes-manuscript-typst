
// workaround for: https://github.com/typst/typst/issues/466
#let balanced-cols(n-cols, gutter: 11pt, body) = layout(bounds => context {
  // Measure the height of the container of the text if it was single
  // column, full width
  let text-height = measure(
    box(
      width: (bounds.width - (n-cols - 1) * gutter) / n-cols,
      body,
    ),
  ).height

  // Recompute the height of the new container. Add a few points to avoid the
  // second column being longer than the first one
  let balanced-height = text-height / n-cols + text.size / 2

  box(
    height: balanced-height,
    columns(n-cols, gutter: gutter, body),
  )
})


// Fake small caps
// taken from https://github.com/csimide/cuti/blob/6e02dc8e9e8d0017a8df6060ec1d2a23a03a6f1b/lib.typ#L50
#let fakesc(s, scaling: 0.75) = {
  show regex("\p{Ll}+"): it => {
    context text(scaling * 1em, tracking: 1pt, upper(it))
  }
  text(s)
}
