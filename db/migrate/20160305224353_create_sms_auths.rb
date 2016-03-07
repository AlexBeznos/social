class CreateSmsAuths < ActiveRecord::Migration
  def change
    create_table :sms_auths do |t|
      t.string :phone
      t.string :code
      t.string :message

      t.timestamps
    end
  end
end
