class GeneratePricesForOrders < ActiveRecord::Migration
  def change
    Order.all.each do |order|
      if order.try(:menu_items) && !order.price
        order.update(price: order.menu_items.inject(0){|sum, item| sum + item.price })
      end
    end
  end
end
