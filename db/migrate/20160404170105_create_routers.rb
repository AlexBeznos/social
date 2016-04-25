class CreateRouters < ActiveRecord::Migration
  def change
    create_table :routers do |t|
      t.string :hp_username
      t.string :hp_password
      t.string :mt_password
      t.string :mt_api_password
      t.string :ip
      t.string :ovpn
      t.string :login_page
      t.string :settings
      t.string :access_token
      t.integer :place_id

      t.timestamps
    end

    add_index :routers, :place_id
    add_index :routers, :ip
    add_index :routers, :access_token
  end
end
