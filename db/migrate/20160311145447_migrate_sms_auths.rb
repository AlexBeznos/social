class MigrateSmsAuths < ActiveRecord::Migration
  def self.up
    Place.where(sms_auth: true).each do |place|
      Auth.create(
        resource_type: 'SmsAuth',
        place: place,
        redirect_url: place.redirect_url,
        resource_attributes: {}
      )
    end
  end

  def self.down
  end
end
