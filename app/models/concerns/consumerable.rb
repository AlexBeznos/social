module Consumerable
  require 'ext/string'
  
  def get_message(place, network)
    place.messages.active.where(social_network: SocialNetwork.find_by(name: network)).first
  end

  def create_consumer(place, credentials) # TODO: make this method as delayed job
    social_network = SocialNetwork.find_by(name: credentials['provider'])

    unless Costumer.where("social_network_id = ? and uid = ?", social_network, credentials['uid']).any?
      case credentials['provider']
      when 'twitter'
        create_twitter_consumer(credentials)
      when 'facebook'
        create_facebook_consumer(credentials)
      end
    end
  end

  private

    def create_twitter_consumer(credentials)
      params = {:social_network => SocialNetwork.find_by(name: 'twitter'),
                :first_name => credentials['info']['name'],
                :url => credentials['info']['urls']['Twitter'],
                :uid => credentials['uid'],
                :access_token => credentials['credentials']['token'],
                :access_token_secret => credentials['credentials']['secret'],
                :expiration_date => Time.now + 1.year,
                :friends_count => credentials['extra']['raw_info']['followers_count']
                }

      params.merge!(get_location(credentials['info']['location']))
      Costumer.create(params)
    end

    def create_facebook_consumer(credentials)
      params = {:social_network => SocialNetwork.find_by(name: 'facebook'),
                :first_name => credentials['info']['first_name'],
                :gender => credentials['extra']['raw_info']['gender'].to_gender,
                :last_name => credentials['info']['last_name'],
                :url => credentials['info']['urls']['Facebook'],
                :uid => credentials['uid'],
                :access_token => credentials['credentials']['token'],
                :expiration_date => Time.now + credentials['credentials']['expires_at'].to_i.seconds,
                }

      params.merge!(get_location(credentials['info']['location']))
      Costumer.create(params)
    end

    def get_location(full_location)
      if full_location && !full_location.empty?
        location = full_location.split(', ')

        {:city => location[0], :country => location[1]}
      else
        {}
      end
    end
end
