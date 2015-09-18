class AddSelectsToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :selects, :integer, default: 0
  end
end
