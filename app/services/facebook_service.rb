class FacebookService
  include Imagable
  attr_accessor :hash

  def initialize(hash)
    @place = hash[:place]
    @message = hash[:message]
    @credentials = hash[:credentials]
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
    friends.raw_response['summary']['total_count']
  end

  def advertise
    graph = Koala::Facebook::API.new(@credentials['token'])

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
