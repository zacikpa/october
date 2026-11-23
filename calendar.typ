#import "@preview/linguify:0.5.0": *
#import "@preview/markly:0.4.0"

#let bleed = 4mm

#let lang_database = toml("data/lang.toml")
#let translate(phrase) = linguify(phrase, from: lang_database)

#let holiday_database = yaml("data/holidays.yaml")
#let name_database = toml("data/names.toml")

#let markly-ctx = markly.setup.with(
  stock-width: 320mm,
  stock-height: 225mm,
  content-width: 297mm,
  content-height: 210mm,
  bleed: bleed,
  bleed-marks: false,
  cut-marks: true,
  registration-marks: true,
)

#let photo-ctx = markly-ctx(
  margin-width: 0mm,
  margin-height: 0mm,
)

#let calendar-ctx = markly-ctx(
  margin-width: 3mm,
  margin-height: 8mm,
)

#let photo(path) = place(
  top + left,
  dx: -bleed,
  dy: -bleed,
  image(
    path,
    width: 297mm + 2 * bleed,
    height: 210mm + 2 * bleed,
  ),
)


#let calendar(year: "", holidays: "", names: "", photos: "", body) = {
  set text(font: "Josefin Sans")

  let have_names = names in name_database
  let have_holidays = holidays in holiday_database

  let print_day(date) = {
    let holiday_info = (
      if not have_holidays {
        none
      } else {
        holiday_database.at(holidays).at(date.display(), default: none)
      }
    )
    let is_non_working_day = (
      date.weekday() in (6, 7)
        or (
          holiday_info != none
            and not holiday_info.at("working", default: false)
        )
    )
    let name_day = (
      if not have_names {
        none
      } else {
        name_database.at(names).at(date.display("[month]-[day]"), default: none)
      }
    )

    let day_display = text(weight: 400)[#date.display(
      "[day padding:none]",
    )]
    if is_non_working_day {
      text(red)[#day_display]
    } else {
      text(black)[#day_display]
    }

    h(0.4em)

    if name_day != none {
      text(0.75em)[#name_day]
    }

    if holiday_info != none {
      align(bottom)[#text(0.75em)[#translate(holiday_info.name)]]
    }
  }

  show: markly.page-setup.with(photo-ctx)

  photo(photos + "/0.jpg")

  let title = translate("calendar") + " " + str(year)
  place(
    top + left,
    dx: -bleed,
    dy: 15mm,
    block(
      fill: rgb(0, 0, 0, 180),
      inset: 16pt,
      radius: 4pt,
      [
        #h(bleed)
        #text(fill: white, size: 30pt, [#title])
      ],
    ),
  )

  pagebreak()

  for month in range(1, 13) [

    #show: markly.page-setup.with(photo-ctx)

    #photo(photos + "/" + str(month) + ".jpg")

    #pagebreak(weak: true)

    #show: markly.page-setup.with(calendar-ctx)

    #let month_date = datetime(
      year: year,
      month: month,
      day: 1,
    )

    #let monthly_days = ()

    #for day in range(0, 31) [
      #let month_accumulator = (month_date + duration(days: day))
      #if month_accumulator.month() != month {
        break
      }
      #monthly_days.push(month_accumulator)
    ]

    #v(8mm)

    #align(left)[
      #heading(level: 1)[
        #text(size: 1.2em, weight: 400)[
          #h(0.4em)
          #translate(lower(month_date.display("[month repr:long]"))) #year
        ]
      ]
    ]

    #v(-1.5em)

    #let first_day = int(monthly_days
      .first()
      .display("[weekday repr:" + { "monday" } + "]"))

    #let week_header = (
      (
        "monday",
        "tuesday",
        "wednesday",
        "thursday",
        "friday",
        "saturday",
        "sunday",
      )
        .map(translate)
        .map(upper)
        .map(align.with(center))
        .map(text.with(weight: 100))
    )

    #let empty_cell = none

    #let monthly_days = (
      range(1, first_day).map(empty_day => empty_cell) + monthly_days
    )

    #show table.cell.where(y: 0): strong
    #pad(
      y: 5%,
      table(
        columns: (1fr,) * 7,
        rows: (0.3fr,) + 5 * (1fr,),
        inset: 0.5em,
        table.header(..week_header),
        ..monthly_days.map(day => {
          if type(day) == type(empty_cell) { return }
          [#print_day(day)]
        }),
        stroke: (x, y) => {
          if y == 0 { return none }
          let cell_index = (y - 1) * 7 + x
          if (
            type(monthly_days.at(cell_index, default: empty_cell))
              == type(empty_cell)
          ) {
            return none
          }
          (thickness: 0.5pt)
        },
      ),
    )

    #pagebreak(weak: true)
  ]
}
