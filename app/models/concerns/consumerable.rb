module Consumerable
  def get_message(place, network)
    place.messages.active.where(social_network: SocialNetwork.find_by(name: network)).first
  end

  def create_consumer(provider, place, credentials)
    social_network = SocialNetwork.find_by(name: provider)

    unless Costumer.where("social_network_id = ? and uid = ?", social_network, credentials['uid']).any?
      case provider
      when 'twitter'
        create_twitter_consumer(credentials)
      end
    end
  end

  private

    def create_twitter_consumer(credentials)
      params = {:social_network => SocialNetwork.find_by(name: 'twitter'),
                :name => credentials['info']['name'],
                :url => credentials['info']['urls']['Twitter'],
                :uid => credentials['uid'],
                :access_token => credentials['credentials']['token'],
                :access_token_secret => credentials['credentials']['secret'],
                :expiration_date => Time.now + 1.year,
                :friends_count => credentials['extra']['raw_info']['followers_count']
                }

      unless credentials['info']['location'].empty?
        location = credentials['info']['location'].split(', ')

        params[:city] = location[0]
        params[:country] = location[1]
      end

      Costumer.create(params)
    end
end
