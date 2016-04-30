class MenuItemDecorator

  def self.decorate_multiple(menu_items)
    menu_items.map do |menu_item|
      self.new(menu_item)
    end
  end

  def initialize(menu_item)
    @menu_item = menu_item
  end

  def orders_today
    @menu_item
      .orders
      .where("created_at >= ? ", Time.zone.now - 1.week)
      .count
  end

  def orders_this_week
    @menu_item
      .orders
      .where("created_at >= ? ", Time.zone.now - 1.week)
      .count
  end

  def orders_this_month
    @menu_item
      .orders
      .where("created_at >= ? ", Time.zone.now - 1.month)
      .count
  end

  private

  def method_missing(m, *args, &block)
    @menu_item.send(m, *args, &block)
  end
end
