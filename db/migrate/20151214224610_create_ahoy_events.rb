class CreateAhoyEvents < ActiveRecord::Migration
  def change
    create_table :ahoy_events, id: false do |t|
      t.integer :id, default: nil, primary_key: true
      t.integer :visit_id, default: nil

      # user
      t.integer :user_id
      # add t.string :user_type if polymorphic

      t.string :name
      t.json :properties
      t.timestamp :time
    end

    add_index :ahoy_events, [:visit_id]
    add_index :ahoy_events, [:user_id]
    add_index :ahoy_events, [:time]
  end
end
