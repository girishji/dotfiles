return {
  parse("gmail", "girishji@gmail.com"),
  s("date", p(os.date, "%Y-%m-%d")),
  s("time", p(os.date, "%H:%M")),
}
