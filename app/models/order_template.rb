class OrderTemplate < ActiveRecord::Base

  belongs_to :location

  has_many :order_template_items, :dependent => :destroy, autosave: true
  has_many :order_template_days, :dependent => :destroy, autosave: true

  def valid_for_date?(date)
    raise ArgumentError.new("Must pass in a valid date") if date.nil?

    valid_day = order_template_days
      .select {|otd| otd.enabled}
      .any? {|otd| otd.day + 1 == date.cwday}

    norm_date = date - (date.cwday - 1)
    norm_start_date = start_date - (start_date.cwday - 1)

    days_since = norm_date - norm_start_date
    weeks_since = (days_since/7).floor

    valid_day && (weeks_since % frequency == 0)
  end
end
