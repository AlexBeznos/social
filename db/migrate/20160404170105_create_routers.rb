class CreateRouters < ActiveRecord::Migration
  def change
    create_table :routers do |t|
      t.string :username
      t.string :password
      t.string :client_ip
      t.string :client_crt
      t.string :client_key
      t.string :client_pass
      t.integer :place_id
      t.boolean :ovpn_ready, default: false

      t.timestamps
    end

    add_index :routers, :place_id
    add_index :routers, :client_ip
  end
end
