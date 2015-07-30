class CreateMenuItemsOrders < ActiveRecord::Migration
  def change
    create_table :menu_items_orders do |t|
      t.belongs_to :menu_item, index: true
      t.belongs_to :order, index: true
    end
  end
end
