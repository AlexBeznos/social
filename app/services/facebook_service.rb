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

  def advertise
    graph = Koala::Facebook::API.new(@credentials['credentials']['token'])

    begin
      graph.put_connections('me', 'feed', {:message => @message.message,
                                            :picture => @message.image.url,
                                            :link => @message.message_link})
    rescue => e
      raise "Facebook message were not sended. Error: #{e.inspect}"
    end
  end
end