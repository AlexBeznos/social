class AddDefaultValuesToPlaces < ActiveRecord::Migration
  def self.up
    Place.update_all({ auth_default_lang: I18n.default_locale })
  end

  def self.down
  end
end
