class VisitWindow < ActiveRecord::Base
  belongs_to :address, optional: true
  has_many :visit_window_days, :dependent => :destroy, autosave: true

  def min_formated
    TimeUtils.minutes_to_formatted min
  end

  def max_formated
    TimeUtils.minutes_to_formatted max
  end
end
