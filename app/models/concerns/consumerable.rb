module Consumerable
  require 'ext/string'

  def get_message(place, network)
    place.messages.active.where(social_network: SocialNetwork.find_by(name: network)).first
  end

  def create_customer(credentials) # TODO: make this method as delayed job
    return  case credentials['provider']
            when 'twitter'
              create_twitter_customer(credentials)
            when 'facebook'
              create_facebook_customer(credentials)
            end
  end

  private

    def create_twitter_customer(credentials)
      params = {
                :first_name => credentials['info']['name'],
                :customer_network_profiles_attributes => [{
                    :social_network => SocialNetwork.find_by(name: 'twitter'),
                    :url => credentials['info']['urls']['Twitter'],
                    :uid => credentials['uid'],
                    :access_token => credentials['credentials']['token'],
                    :access_token_secret => credentials['credentials']['secret'],
                    :expiration_date => Time.now + 1.year,
                    :friends_count => credentials['extra']['raw_info']['followers_count']
                  }]
                }

      params[:customer_network_profiles_attributes][0].merge!(get_location(credentials['info']['location']))
      create_customer_by_params(params)
    end

    def create_facebook_customer(credentials)
      params = {
                :first_name => credentials['info']['first_name'],
                :last_name => credentials['info']['last_name'],
                :gender => credentials['extra']['raw_info']['gender'].to_gender,
                :customer_network_profiles_attributes => [{
                    :social_network => SocialNetwork.find_by(name: 'facebook'),
                    :url => credentials['info']['urls']['Facebook'],
                    :uid => credentials['uid'],
                    :access_token => credentials['credentials']['token'],
                    :expiration_date => Time.now + credentials['credentials']['expires_at'].to_i.seconds,
                  }]
                }

      params[:customer_network_profiles_attributes][0].merge!(get_location(credentials['info']['location']))
      create_customer_by_params(params)
    end

    def get_location(full_location)
      if full_location && !full_location.empty?
        location = full_location.split(', ')

        {:city => location[0], :country => location[1]}
      else
        {}
      end
    end

    def create_customer_by_params(params)
      customer = Customer.new(params)

      if customer.save
        customer
      else
        raise "Customer not created, error: #{customer.errors.inspect}"
      end
    end
end
