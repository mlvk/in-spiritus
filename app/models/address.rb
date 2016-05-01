class Address < ActiveRecord::Base
  has_many :locations

  def to_s
    '1 East Park Pl'
    "#{street.titleize}\n#{city.titleize}, #{state.upcase} #{zip}"
  end
end
