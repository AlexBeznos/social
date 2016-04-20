class RenameUserIdToCustomerId < ActiveRecord::Migration
  def change
    rename_column :ahoy_visits, :user_id, :customer_id
  end
end
