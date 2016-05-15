class Address < ActiveRecord::Base
  has_many :locations
  has_many :visit_windows
  has_many :route_visits
  has_many :route_plan_blueprints

  def to_s
    "#{street.titleize}\n#{city.titleize}"
  end
end
