class VisitWindow < ActiveRecord::Base
  belongs_to :address
  has_many :visit_window_days, :dependent => :destroy, autosave: true
end
