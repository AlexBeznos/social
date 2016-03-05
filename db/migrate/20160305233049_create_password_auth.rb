class CreatePasswordAuth < ActiveRecord::Migration
  def change
    create_table :password_auths do |t|
      t.string :password
    end
  end
end
