class AddImageToMenuItem < ActiveRecord::Migration
  def change
    add_attachment :menu_items, :image
  end
end
