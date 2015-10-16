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

    begin
      graph.put_connections('me', 'feed', { :message => hash[:message].message,
                                            :picture => hash[:message].image.url,
                                            :link => hash[:message].message_link })
    rescue => e
      raise "Facebook message were not sent. Error: #{e.inspect}"
    end
  end
end
