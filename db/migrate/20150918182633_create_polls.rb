class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.text :question
      t.integer :answers_number
      t.references :user, index: true, foreign_key: true
      t.timestamps
    end
  end
end
