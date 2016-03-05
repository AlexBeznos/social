class ChangeAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :poll_auth_id, :integer
  end
end
