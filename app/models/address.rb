class Address < ActiveRecord::Base
  has_many :locations
end
