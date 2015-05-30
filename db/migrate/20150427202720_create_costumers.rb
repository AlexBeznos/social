class CreateCostumers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :age
      t.string :birthday
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
