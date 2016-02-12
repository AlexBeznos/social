class CreatePreviews < ActiveRecord::Migration
  def change
    create_table :previews do |t|

      t.timestamps
    end
  end
end
