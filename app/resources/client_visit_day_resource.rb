class ClientVisitDayResource < JSONAPI::Resource
  attributes :day, :enabled
  has_one :client
end
