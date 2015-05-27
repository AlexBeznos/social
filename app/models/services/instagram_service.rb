class FacebookService
  include Consumerable
  attr_accessor :hash

  def initialize(hash)
    @place = hash[:place]
    @credentials = hash[:credentials]
  end

  def self.get_user_id(user_name)
    Instagram.user_search(user_name, :count => 1).first['id']
  end

  def advertise
    message = get_message(@place, @credentials['provider'])
    client = Instagram.client(:access_token => @credentials['credentials']['token'])

    begin
      client.follow_user(message.subscription_uid)
    rescue => e
      Rails.logger.fatal "Twitter message was not posted. Error: #{e}"
    end

    message.redirect_link
  end
end
