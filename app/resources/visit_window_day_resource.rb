class VisitWindowDayResource < JSONAPI::Resource
  attributes  :day,
              :enabled

  has_one :visit_window
end
