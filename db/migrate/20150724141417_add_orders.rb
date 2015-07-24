class AddOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.belongs_to :customer, index: true
      t.belongs_to :menu_item, index: true

      t.timestamps
    end
  end
end