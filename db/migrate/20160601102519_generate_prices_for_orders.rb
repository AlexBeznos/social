class GeneratePricesForOrders < ActiveRecord::Migration
  def change
    Order.all.each do |order|
      unless order.menu_items.empty? && order.price
        order.update(price: order.menu_items.inject(0){|sum, item| sum + item.price })
      end
    end
  end
end
