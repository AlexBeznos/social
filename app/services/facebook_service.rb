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
    attrs = if hash[:hash]
              { message: hash[:message]['message'], link: hash[:message]['message_link'], picture: hash[:message]['image_file_name'] }
            else
              { message: hash[:message].message, link: hash[:message].message_link, picture: hash[:message].image.url }
            end

    begin
      graph.put_connections('me', 'feed', { :message => attrs[:message],
                                            :picture => attrs[:picture],
                                            :link => attrs[:link] })
    rescue => e
      raise "Facebook message were not sended. Error: #{e.inspect}"
    end
  end
end
