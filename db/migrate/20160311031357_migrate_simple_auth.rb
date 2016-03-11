class MigrateSimpleAuth < ActiveRecord::Migration
  def self.up
    Place.where(simple_enter: true).each do |place|
      Auth.create(
        resource_type: 'SimpleAuth',
        place: place,
        redirect_url: place.redirect_url,
        resource_attributes: {}
      )
    end
  end

  def self.down
  end
end
