#import "@preview/tidy:0.4.2"

#{
  let docs = tidy.parse-module(read("../src/lib.typ"))
  set heading(numbering: none)
  tidy.show-module(docs, style: tidy.styles.default)
}
