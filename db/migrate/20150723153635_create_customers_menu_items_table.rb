class CreateCustomersMenuItemsTable < ActiveRecord::Migration
  def change
    create_table :customers_menu_items do |t|
      t.integer :customer_id, index: true
      t.integer :menu_item_id, index: true
    end
  end
end
