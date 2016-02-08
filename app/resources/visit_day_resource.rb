class VisitDayResource < JSONAPI::Resource
  attributes :day,
             :enabled
             
  has_one :location
end
