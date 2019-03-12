class VisitDay < ActiveRecord::Base
  belongs_to :location, optional: true
end
