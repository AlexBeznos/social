class CreatePollAuths < ActiveRecord::Migration
  def change
    create_table :poll_auths do |t|
      t.text :question
      t.timestamps
    end
  end
end
