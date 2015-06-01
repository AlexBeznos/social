module Consumerable
  require 'ext/string'

  def get_message(place, network)
    place.messages.active.where(social_network: SocialNetwork.find_by(name: network)).first
  end

  def find_or_create_costumer(credentials, place, customer = false) # TODO: make this method as delayed job
    profiles = Customer::NetworkProfile.where("uid = ? and social_network_id = ?", credentials[:uid], SocialNetwork.find_by(name: credentials['provider']))

    if profiles.any?
      create_visit(profiles.first, place)

      return profiles.first.customer
    else
      if customer
        profile = customer.network_profiles.create(get_network_profile_params(credentials))
      else
        customer = create_customer(credentials)
        profile = customer.network_profiles.last
      end

      create_visit(profile, place)
      customer
    end
  end

  def create_customer(credentials)
    return  case credentials['provider']
            when 'twitter'
              create_twitter_customer(credentials)
            when 'facebook'
              create_facebook_customer(credentials)
            end
  end

  def create_visit(network_profile, place)
    Customer::Visit.create( customer_network_profile_id: network_profile.id,
                            place: place)
  end

  private

    def create_twitter_customer(credentials)
      params = get_twitter_params(credentials)
      create_customer_by_params(params)
    end

    def create_facebook_customer(credentials)
      params = get_facebook_params(credentials)
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

    def get_twitter_params(credentials)
      params = {
                :first_name => credentials['info']['name'],
                :last_name => nil,
                :network_profiles_attributes => [get_network_profile_params(credentials)]
                }

      params.merge!(get_location(credentials['info']['location']))
      params
    end

    def get_facebook_params(credentials)
      params = {
                :first_name => credentials['info']['first_name'],
                :last_name => credentials['info']['last_name'],
                :gender => credentials['extra']['raw_info']['gender'].to_gender,
                :network_profiles_attributes => [get_network_profile_params(credentials)]
                }

      params.merge!(get_location(credentials['info']['location']))
      params
    end

    def get_network_profile_params(credentials)
      return  case credentials['provider']
              when 'facebook'
                {
                  :social_network => SocialNetwork.find_by(name: 'facebook'),
                  :url => credentials['info']['urls']['Facebook'],
                  :uid => credentials['uid'],
                  :access_token => credentials['credentials']['token'],
                  :expiration_date => Time.now + credentials['credentials']['expires_at'].to_i.seconds
                }
              when 'twitter'
                {
                  :social_network => SocialNetwork.find_by(name: 'twitter'),
                  :url => credentials['info']['urls']['Twitter'],
                  :uid => credentials['uid'],
                  :access_token => credentials['credentials']['token'],
                  :access_token_secret => credentials['credentials']['secret'],
                  :expiration_date => Time.now + 1.year,
                  :friends_count => credentials['extra']['raw_info']['followers_count']
                }
              end
    end
end
