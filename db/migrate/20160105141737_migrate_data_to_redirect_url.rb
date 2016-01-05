class MigrateDataToRedirectUrl < ActiveRecord::Migration
  def self.up
    Message.find_each do |message|
      message.update(redirect_url: message.wih_message.redirect_url) if message.with_message.is_a? Place
    end
  end

  def self.down
  end
end
