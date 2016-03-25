class CreateInstagramAuth < ActiveRecord::Migration
  def change
    create_table :instagram_auths do |t|
      t.timestamps
    end
  end
end
