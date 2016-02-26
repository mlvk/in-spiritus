class VisitWindow < ActiveRecord::Base
  belongs_to :location
  has_many :route_visits
  has_many :visit_window_days, :dependent => :destroy, autosave: true
end
