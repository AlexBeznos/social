class MenuItemDecorator

  def initialize(menu_item)
    @menu_item = menu_item
  end

  def orders_today
    @menu_item.orders.count do |order|
      order.updated_at.today?
    end
  end

  def orders_by_week
    menu_item.orders.count do |order|
      order.updated_at <= (Time.now - 7.days)
    end
  end

  def orders_by_month
    menu_item.orders.count do |order|
      order.updated_at <= (Time.now - 1.month)
    end
  end
end
