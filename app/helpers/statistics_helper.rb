module StatisticsHelper
  def ordered_by_day(item, orders)
    orders.count do |order|
      order.today? &&
        order.menu_items.include?(item)
    end
  end

  def ordered_by_week(item, orders)

  end

  def ordered_by_month(item)

  end
end
