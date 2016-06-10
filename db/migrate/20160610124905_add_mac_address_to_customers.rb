class AddMacAddressToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :mac_address, :string
  end
end
