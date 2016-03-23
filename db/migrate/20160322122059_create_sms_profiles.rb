class CreateSmsProfiles < ActiveRecord::Migration
  def change
    create_table :sms_profiles do |t|
      t.string :number
      t.string :code

      t.timestamps
    end
  end
end
