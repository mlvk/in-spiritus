class VisitWindowDay < ActiveRecord::Base
  belongs_to :visit_window, optional: true
end
