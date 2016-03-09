class CreateSimpleAuths < ActiveRecord::Migration
  def change
    create_table :simple_auths do |t|

      t.timestamps
    end
  end
end
