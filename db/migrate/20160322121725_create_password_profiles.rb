class CreatePasswordProfiles < ActiveRecord::Migration
  def change
    create_table :password_profiles do |t|
      t.timestamps
    end
  end
end
