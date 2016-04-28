class CreateSmsProfiles < ActiveRecord::Migration
  def change
    create_table :sms_profiles do |t|
      t.string :phone
      t.string :code
      t.boolean :used, default: false

      t.timestamps
    end
  end
end
