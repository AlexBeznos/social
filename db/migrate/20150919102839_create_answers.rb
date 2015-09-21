class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :content
      t.integer :poll_id
      t.integer :number_of_selections, :null => false, :default => 0
      t.timestamps
    end
    add_index :answers, :poll_id
  end
end
