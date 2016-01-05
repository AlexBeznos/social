class AddRedirectUrlToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :redirect_url, :string
  end
end
