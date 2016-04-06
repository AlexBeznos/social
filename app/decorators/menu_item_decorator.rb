class MenuItemDecorator
  def self.decorate_multiple(menu_items)
    menu_items.map do |item|
      self.new(item)
    end
  end

  def initialize(menu_item)
    @menu_item = menu_item
  end

  def orders_today
    @menu_item.orders.to_ary.count do |order|
      order.updated_at.today?
    end
  end

  def orders_by_week
    @menu_item.orders.to_ary.count do |order|
      order.created_at >= (Time.now - 7.days)
    end
  end

  def orders_by_month
    @menu_item.orders.to_ary.count do |order|
      order.created_at >= (Time.now - 1.month)
    end
  end

  private

  def method_missing(m, *args, &block)
    @menu_item.send(m, *args, &block)
  end
end
