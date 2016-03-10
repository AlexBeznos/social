class FacebookService
  attr_accessor :hash

  def initialize(hash)
    @place = hash[:place]
    @message = hash[:message]
    @credentials = hash[:credentials]
  end

  def self.get_friends_number(costumer)
    graph = Koala::Facebook::API.new(costumer.access_token)

    begin
      friends = graph.get_connections('me', 'friends')
      friends.raw_response['summary']['total_count']
    rescue => e
      Rails.logger.error "Facebook friends number error. Error: #{e.inspect}"
      0
    end
  end

  def self.advertise(hash)
    graph = Koala::Facebook::API.new(hash[:credentials]['credentials']['token'])

    graph.put_connections('me', 'feed', { :message => hash[:message].message,
                                          :picture => "http:#{hash[:message].image.url}",
                                          :link => hash[:message].message_link })
  end

  def self.check_publish_permission(hash)
    graph = Koala::Facebook::API.new(hash['credentials']['token'])
    permissions = graph.get_connection('me', 'permissions')
    publish_status = permissions.find { |h| h['permission'] == 'publish_actions' }['status']

    publish_status == 'granted'
  end
end
