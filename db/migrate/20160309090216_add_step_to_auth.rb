class AddStepToAuth < ActiveRecord::Migration
  def change
    add_column :auths, :step, :integer, default: 0
  end
end
