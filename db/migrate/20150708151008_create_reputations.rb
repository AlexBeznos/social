class CreateReputations < ActiveRecord::Migration
  def change
    create_table :customer_reputations do |t|
      t.integer :score

      t.timestamps
    end

    add_reference :customer_reputations, :place, index: true
    add_reference :customer_reputations, :customer, index: true
  end
end
