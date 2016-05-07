class Address < ActiveRecord::Base
  has_many :locations
  has_many :visit_windows
  has_many :route_visits

  def to_s
    "#{street.titleize}\n#{city.titleize}, #{state.upcase} #{zip}"
  end
end
