class CreateSmsAuths < ActiveRecord::Migration
  def change
    create_table :sms_auths do |t|
      t.timestamps
    end
  end
end
