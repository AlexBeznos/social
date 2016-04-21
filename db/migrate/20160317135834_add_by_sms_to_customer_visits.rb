class AddBySmsToCustomerVisits < ActiveRecord::Migration
  def change
    add_column :customer_visits, :by_sms, :boolean, default: false
  end
end
