class AddRememberSmsToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :remember_sms, :boolean, defaullt: false
  end
end
