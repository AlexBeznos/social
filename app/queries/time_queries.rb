module  TimeQueries
  def created_in_peroid(args={})
    if args[:from] && args[:to]
      self.where(created_at: args[:from]..args[:to])
    end
  end

  def created_today
    self.created_in_peroid(
      from: Time.zone.now.beginning_of_day,
      to: Time.zone.now.end_of_day
    )
  end

  def created_this_week
    self.created_in_peroid(
      from: Time.zone.now - 7.days,
      to: Time.zone.now
    )
  end

  def created_this_month
    self.created_in_peroid(
      from: Time.zone.now - 1.month,
      to: Time.zone.now
    )
  end
end
