class CreateRouters < ActiveRecord::Migration
  def change
    create_table :routers do |t|
      t.string :username
      t.string :password
      t.string :client_ip
      t.string :ovpn
      t.string :login_page
      t.string :settings
      t.string :access_token
      t.integer :place_id

      t.timestamps
    end

    add_index :routers, :place_id
    add_index :routers, :client_ip
  end
end
