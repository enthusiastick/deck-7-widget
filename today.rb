class Today
  def self.at_beginning_of_day
    Time.new(now.year, now.month, now.day, -offset_in_hours).getlocal(offset)
  end

  def self.at_end_of_day
    Time.new(now.year, now.month, now.day + 1, -offset_in_hours).getlocal(offset)
  end

  def self.day
    now.to_date.day
  end

  def self.now
    Time.now.getlocal(offset)
  end

  def self.offset
    '%+.2d:00' % offset_in_hours
  end

  def self.offset_in_hours
    timezone = TZInfo::Timezone.get(ENV["TIMEZONE_STRING"])
    timezone.current_period.utc_total_offset_rational.numerator
  end
end
