class MigratePasswordAuths < ActiveRecord::Migration
  def self.up
    Place.where(enter_by_password: true).each do |place|
      Auth.create(
        resource_type: 'PasswordAuth',
        place: place,
        redirect_url: place.redirect_url,
        resource_attributes: {
          password: place.password
        }
      )
    end
  end

  def self.down
  end
end
