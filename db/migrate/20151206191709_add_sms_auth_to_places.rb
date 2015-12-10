class AddSmsAuthToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :sms_auth, :boolean, default: false
  end
end
