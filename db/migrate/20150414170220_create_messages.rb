class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :type
      t.text :attachments
      t.string :redirect_link
      t.text :message
      t.string :message_link
      t.integer :place_id

      t.timestamps
    end
  end
end
