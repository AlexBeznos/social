class AddStateToAuth < ActiveRecord::Migration
  def change
    add_column :auths, :state, :integer
  end
end
