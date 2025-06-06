#import "@preview/hydra:0.6.1": hydra

#import "cover-bg.typ": cover-bg
#import "abstracts-bg.typ": abstracts-bg
#import "utils.typ": balanced-cols, fakesc

#let school-color-recto = blue
#let school-color-verso = rgb("0054a0")
#let cover-page-margins = (left: 20mm, right: 20mm, top: 10mm, bottom: 10mm)

#let cover-font = "Helvetica"
#let main-font = "Newsreader"
#let title-font = "UniRennes"

#let logo-header = block(
  // width: 70% + page-margins.left + page-margins.right,
  width: 100%,
  inset: (left: -cover-page-margins.left + 10%, right: -cover-page-margins.left + 10%),
  align(
    horizon,
    stack(
      dir: ltr,
      spacing: 1fr,
      image("assets/matisse.png", width: 90mm),
      image("../common/assets/logos/unirennes-logo.svg", width: 80mm),
    ),
  ),
)

#let cover(
  title-en: "",
  title-fr: "",
  author: "",
  affiliation: "",
  defense-place: "",
  defense-date: "",
  jury: (),
  supervision: (),
  thesis-number: "",
) = {
  set page(
    "a4",
    margin: cover-page-margins,
    header: none,
    numbering: none,
  )
  set text(font: cover-font, fill: black)

  let logo-overhang = (x: 7mm, y: -15mm)
  [#logo-header<cover:logos>]


  // When exporting to PDF, the transparency of the gradients is lost, thus we
  // need to use the fix suggested in
  // https://forum.typst.app/t/is-there-a-workaround-for-having-transparent-gradients-in-pdf-exports/1036
  // while the issue https://github.com/typst/typst/issues/5774 is not fixed
  // place(dx: -20mm, dy: 30mm, cover-bg(school-color-recto))
  context {
    place(
      top + left,
      dx: -cover-page-margins.left,
      dy: 1cm,
      [#image(width: 100% + cover-page-margins.left + cover-page-margins.right, "assets/cover-bg.svg")<cover:bg-image>],
    )
  }

  text(size: 26pt, fakesc[Thèse de doctorat de<cover:thesis-text>])
  v(2.25cm)

  // Add a blue background with the width of the page
  let blue-bg-overhang = 1cm
  context {
    let y-start = (
      measure(query(<cover:bg-image>).first()).height
        + locate(<cover:thesis-text>).position().y
        + measure(query(<cover:logos>).first()).height
    )
    let y-end = locate(<cover:defense-info>).position().y - cover-page-margins.top - blue-bg-overhang / 2

    place(
      top + left,
      dy: y-start,
      dx: -cover-page-margins.left,
      block(
        width: page.width,
        height: y-end - y-start,
        fill: school-color-recto,
      ),
    )
  }


  set text(fill: white)
  text(size: 14pt, weight: "bold", fakesc[l'Université de Rennes])
  v(.01cm)
  text(size: 11pt)[
    #fakesc()[École Doctorale N° 601] \
    _Mathématiques, Télécommunications, Informatique, \
    Signal, Systèmes, Électronique_ \
    Spécialité : _Informatique_
  ]

  // Author name
  v(12pt)
  h(.6cm) + text(size: 12pt)[Par \ ]
  h(.6cm) + text(size: 20pt)[*#author* \ ]
  v(12pt)

  // Title + defense info block
  text(size: 16pt)[*#title-en* <cover:title-en>]
  parbreak()
  text(size: 14pt, title-fr)
  parbreak()

  text(size: 11pt)[
    *Thèse présentée et soutenue à #defense-place, le #defense-date* \
    *Unité de recherche : #affiliation*\
    #if thesis-number != "" [
      *Thèse N° : #thesis-number*
    ]
  ]
  v(blue-bg-overhang / 2)

  // Defense and supervisors
  [#block(
      inset: (left: 16pt),
      {
        set text(fill: black, size: 10pt)

        text(size: 12pt, weight: "bold")[Rapporteur·trice·s avant soutenance : ]
        table(
          columns: 2,
          stroke: none,
          column-gutter: 20pt,
          inset: (x: 0pt, y: 2pt),
          ..for (name, affiliation) in jury.at("rapporteurs") { (name, affiliation) }
        )

        text(size: 12pt, weight: "bold")[Composition du Jury : ]
        table(
          columns: 3,
          stroke: none,
          column-gutter: (10pt, 50pt),
          inset: (x: 0pt, y: 2pt),
          [Président·e :], ..jury.at("president"),
          [Examinateur·ice·s :], ..jury.at("examinateurs").first(),
          ..for (name, affiliation) in jury.at("examinateurs").slice(1) { ("", name, affiliation) },
          [Direction :], ..supervision.at("directeurs").first(),
          ..for (name, affiliation) in supervision.at("directeurs").slice(1) { ("", name, affiliation) },
          ..if "encadrants" in supervision {
            (
              [Encadrement :],
              ..supervision.at("encadrants").first(),
              ..for (name, affiliation) in supervision.at("encadrants").slice(1) { ("", name, affiliation) },
            )
          }
        )

        if "invites" in jury {
          text(size: 12pt, weight: "bold")[Invité·e·s : ]
          table(
            columns: 2,
            stroke: none,
            column-gutter: 20pt,
            inset: (x: 0pt, y: 2pt),
            ..for (name, affiliation) in jury.at("invites") { (name, affiliation) }
          )
        }
      },
    )<cover:defense-info>]

  pagebreak()
}

#let abstracts(
  title-fr: "",
  keywords-fr: "",
  abstract-fr: [],
  title-en: "",
  keywords-en: "",
  abstract-en: [],
) = {
  // Set the page dimensions and skip the required number of pages
  set page(
    "a4",
    numbering: none,
    header: none,
    margin: cover-page-margins,
  )
  pagebreak(to: "odd", weak: true)

  // Set the page background
  set page(background: image("assets/abstracts-bg.svg"))

  set text(font: "TeX Gyre Heros", fill: black)

  [#logo-header<cover:logos>]
  v(2cm)
  line(length: 100%, stroke: .2cm + school-color-verso)
  v(.4cm)

  [
    #show linebreak: none
    #text(school-color-verso)[*Titre :*] #title-fr
  ]

  [

    *Mots clés :* #keywords-fr
  ]

  balanced-cols(2, gutter: 11pt)[*Résumé :* #abstract-fr]

  v(1cm)
  line(length: 100%, stroke: .2cm + school-color-verso)
  v(.4cm)

  [
    #show linebreak: none
    #text(school-color-verso)[*Title:*] #title-en
  ]

  [

    *Keywords:* #keywords-en
  ]

  balanced-cols(2, gutter: 11pt)[*Abstract:* #abstract-en]

  // Reset background a make sure that the last page is an even empty page
  set page(background: none)
  pagebreak(to: "even")
}

// Divide the manuscript into parts. The Chapters still use the `= ` syntactic
// sugar and are numbered independently of parts.
#let part(title) = heading(level: 1, outlined: true, numbering: "I", title)

#let matisse-thesis(
  author: "",
  affiliation: "",
  title-en: "",
  title-fr: "",
  keywords-fr: "",
  keywords-en: "",
  abstract-en: [],
  abstract-fr: [],
  acknowledgements: [],
  jury: (),
  supervision: (),
  defense-place: "",
  defense-date: "",
  thesis-number: "",
  draft: true,
  body-paper: "a4",
  body,
) = {
  // ------------ GENERAL SETTINGS ------------ //
  let draft-string = ""
  if draft { draft-string = "DRAFT - " }
  set document(
    author: author,
    title: draft-string + title-en,
  )
  set par(justify: true)
  set text(font: main-font, size: 10pt, fill: black, lang: "en")

  set page(
    body-paper,
    // ------------ MARGINS ------------ //
    margin: (outside: 15mm, inside: 20mm, top: 15mm, bottom: 15mm),

    // ------------ PAGE NUMBERS ------------ //
    numbering: "1",
    number-align: center,

    // ------------ HEADER ------------ //
    header: context {
      // disable linebreaks in header
      show linebreak: none

      // get the current page number
      let current-page = here().page()
      // let current-page = counter(page).get().first()

      // if the page starts a level-2 heading (i.e., chapters), display nothing
      let all-chapters = query(heading.where(level: 2))
      if all-chapters.any(it => it.location().page() == current-page) {
        return
      }

      // if the page is odd vs even
      if calc.odd(current-page) {
        // display the last level-2 heading (i.e., chapters)
        let header-content = hydra(
          2,
          display: (_, it) => {
            if it.numbering != none {
              let nb = counter(heading).at(it.location())
              let nb-fmt = numbering(it.numbering, ..nb)
              [#it.supplement #nb-fmt -- _ #it.body _]
            } else { emph(it.body) }
          },
        )
        text(0.35cm, header-content)
      } else {
        // display last level-3 heading (current page included)
        let header-content = hydra(
          3,
          use-last: true,
          display: (_, it) => {
            if it.numbering == none [_ #it.body _] else {
              let nb = counter(heading).at(it.location())
              let nb-fmt = numbering(
                it.numbering,
                ..nb,
              )
              [_ #nb-fmt #it.body _]
            }
          },
        )
        align(right, text(0.35cm, header-content))
      }

      // horizontal rule
      v(-.3cm)
      line(length: 100%, stroke: .2mm)
    },
  )

  // ------------ HEADINGS ------------ //
  set heading(
    offset: 1,
    // Custom function Numbering to avoid printing parts
    numbering: (..nums) => {
      nums.pos().slice(1).map(str).join(".")
    },
  )

  // By convention, level 1 headings are parts
  show heading.where(level: 1): set heading(supplement: [Part])
  show heading.where(level: 1): it => {
    set page(numbering: none, header: none)
    set align(center + horizon)
    pagebreak(to: "odd")

    text(
      size: 24pt,
      weight: "regular",
      font: "UniRennes Inline",
      smallcaps[#it.supplement #it.numbering],
    )
    v(0.5cm)
    text(smallcaps(it.body), font: title-font, size: 28pt)
  }

  // By convention, level 2 headings are chapters
  show heading.where(level: 2): set heading(supplement: [Chapter])
  show heading.where(level: 2): it => context {
    // always start on odd pages and make sure that there is no headers on hte blank pages
    {
      set page(numbering: none, header: none)
      pagebreak(to: "odd")
    }
    set align(right)

    // Whether or not to display the chapter number/supplement "Chapter X". E.g.
    // for the acknowledgements, we do not display it
    if it.numbering != none {
      let sec-nb = counter(heading).get().at(1)
      let fmt-nb = numbering("1.1", sec-nb)
      text(
        size: 24pt,
        weight: "regular",
        font: "UniRennes Inline",
        smallcaps[#heading.supplement #fmt-nb],
      )
    }
    parbreak()

    // Heading name
    text(smallcaps(it.body), font: title-font, size: 28pt)
    set align(left)

    // horizontal rule
    line(length: 100%, stroke: .2mm)
    v(.7cm)
  }

  // ------------ FIGURES ------------ //
  show figure.caption: it => box(
    inset: (left: 1em, right: 1em),
    align(left, it),
  )

  // ------------ OUTLINE ------------ //
  show outline: o => {
    show outline.entry.where(level: 1): e => {
      v(5mm, weak: true)
      strong(e)
    }
    show outline.entry.where(level: 2): e => {
      v(5mm, weak: true)
      strong(e)
    }
    show outline.entry.where(level: 3): e => {
      emph(e)
    }
    o
  }
  // Parts and Chapters should have the same indentation level on outline
  set outline(
    indent: n => {
      if n == 0 or n == 1 {
        0em
      } else {
        (n - 1) * 1em
      }
    },
  )

  // disable linebreaks in outline
  show outline.entry: it => {
    show linebreak: none
    it
  }

  // ------------ MATH ------------ //
  // will be available in 0.12
  show math.equation: it => {
    // small caps with a compliant font
    show smallcaps: set text(font: "Libertinus Serif")
    it
  }

  // ------------ FOOTNOTES ------------ //
  show footnote.entry: it => {
    let loc = it.note.location()
    numbering(
      "1. ",
      ..counter(footnote).at(loc),
    )
    it.note.body
  }

  // ------------ BIBLIOGRAPHY ------------ //
  set bibliography(style: "association-for-computing-machinery")

  // ------------ COVER PAGE ------------ //
  cover(
    title-en: draft-string + title-en,
    title-fr: draft-string + title-fr,
    author: author,
    affiliation: affiliation,
    defense-place: defense-place,
    defense-date: defense-date,
    thesis-number: thesis-number,
    jury: jury,
    supervision: supervision,
  )

  // ------------ BODY ------------ //
  body
  pagebreak(to: "odd")

  // ------------ ABSTRACT ------------ //
  abstracts(
    title-fr: title-fr,
    keywords-fr: keywords-fr,
    abstract-fr: abstract-fr,
    title-en: title-en,
    keywords-en: keywords-en,
    abstract-en: abstract-en,
  )
}
