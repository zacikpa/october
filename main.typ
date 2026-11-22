#import "calendar.typ": calendar

#set text(lang: sys.inputs.lang)

#show: calendar.with(
  year: int(sys.inputs.year),
  holidays: sys.inputs.holidays,
  names: sys.inputs.names,
  photos: sys.inputs.photos,
)
