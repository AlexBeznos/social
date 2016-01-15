class AddAuthDefaultLangToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :auth_default_lang, :string 
  end
end
