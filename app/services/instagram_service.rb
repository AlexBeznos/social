class InstagramService
  include Advertisable
  attr_accessor :hash

  def initialize(hash)
    @place = hash[:place]
    @credentials = hash[:credentials]
  end

  def advertise
    puts @credentials
    message = get_message(@place, @credentials['provider'])

    client = Instagram.client(:access_token => @credentials['credentials']['access_token'])
    client.follow_user(message.subscription_uid)

    message.redirect_link
  end
end
