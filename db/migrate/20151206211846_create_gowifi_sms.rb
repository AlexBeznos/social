class CreateGowifiSms < ActiveRecord::Migration
  def change
    create_table :gowifi_sms do |t|
      t.string :phone
      t.string :code
      t.integer :place_id

      t.timestamps
    end

    add_index :gowifi_sms, :place_id
  end
end
