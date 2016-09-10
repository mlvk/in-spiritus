class TimeUtils
  def self.minutes_to_formatted minutes
    raise 'minutes is not a number' unless minutes.kind_of? Integer
    (Time.new(0) + minutes * 60).strftime('%H:%M')
  end
end
