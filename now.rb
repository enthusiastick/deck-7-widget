require "TZInfo"

class Now
  def self.eastern
    timezone_name = "US/Eastern"

    timezone = TZInfo::Timezone.get(timezone_name)
    offset_in_hours = timezone.current_period.utc_total_offset_rational.numerator
    offset = '%+.2d:00' % offset_in_hours

    Time.now.getlocal(offset)
  end
end
