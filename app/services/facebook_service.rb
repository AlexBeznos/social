class FacebookService
  include Imagable
  attr_accessor :hash

  def initialize(hash)
    @place = hash[:place]
    @message = hash[:message]
    @profile = hash[:profile]
  end

  def self.get_token(credentials)
    {
      'provider' => credentials['provider'],
      'token' => credentials['credentials']['token']
    }
  end

  def self.get_friends_number(token)
    graph = Koala::Facebook::API.new(token)
    friends = graph.get_connections('me', 'friends')
    friends.raw_response.fetch('summary', {})
                        .fetch('total_count', 0)
  end

  def advertise
    graph = Koala::Facebook::API.new(@profile.access_token)

    graph.put_connections('me', 'feed', {
      message: @message.message,
      picture: to_full_url(@message.image.url),
      link: @message.message_url
    })
  end

  def self.publishing_permitted?(token)
    graph = Koala::Facebook::API.new(token)
    permissions = graph.get_connection('me', 'permissions')
    publish_status = permissions.find { |h| h['permission'] == 'publish_actions' }['status']
    publish_status == 'granted'
  end
end
