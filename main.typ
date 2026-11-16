#import "calendar.typ": calendar

#set text(lang: "sk")

#show: calendar.with(
  year: datetime.today().year() + 1,
  holidays: "CZ",
  names: "SK",
  photos: "photos/martinka",
)
