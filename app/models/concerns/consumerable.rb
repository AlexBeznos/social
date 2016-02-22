module Consumerable
  require 'ext/string'

  def get_message(place, network)
    place.messages.active.where(social_network: SocialNetwork.find_by(name: network)).first
  end

  def find_or_create_costumer(credentials, place, customer = false)
    profiles = Customer::NetworkProfile.where("uid = ? and social_network_id = ?", credentials['uid'], SocialNetwork.find_by(name: credentials['provider']).id)

    if profiles.any?
      visit = create_visit(profiles.first, place)
      update_profile(profiles.first, credentials)
      return {:customer => profiles.first.customer, :visit => visit.errors.any?}
    else
      if customer
        profile = customer.network_profiles.create(get_network_profile_params(credentials))
      else
        customer = create_customer(credentials)
        profile = customer.network_profiles.last
      end

      visit = create_visit(profile, place)
      {:customer => customer, :visit => visit.errors.any?}
    end
  end

  def create_customer(credentials)
    return  case credentials['provider']
            when 'twitter'
              create_twitter_customer(credentials)
            when 'facebook'
              create_facebook_customer(credentials)
            when 'vkontakte'
              create_vkontakte_customer(credentials)
            when 'instagram'
              create_instagram_customer(credentials)
            end
  end

  def create_visit(network_profile, place)
    Customer::Visit.create( customer_network_profile_id: network_profile.id,
                            customer_id: network_profile.customer_id,
                            place: place)
  end

  def create_visit_by_password(place)
    Customer::Visit.create(place: place, by_password: true)
  end

  private

    def update_profile(network_profile, credentials)
      network_profile.update(get_network_profile_params(credentials))
    end

    def create_twitter_customer(credentials)
      params = get_twitter_params(credentials)
      create_customer_by_params(params)
    end

    def create_facebook_customer(credentials)
      params = get_facebook_params(credentials)
      create_customer_by_params(params)
    end

    def create_vkontakte_customer(credentials)
      params = {
        :first_name => credentials['extra']['raw_info']['first_name'],
        :last_name => credentials['extra']['raw_info']['last_name'],
        :gender => credentials['extra']['raw_info']['sex'].to_s.to_gender!,
        :birthday => get_date(credentials['extra']['raw_info']['bdate']),
        :network_profiles_attributes => [get_network_profile_params(credentials)]
      }

      create_customer_by_params(params)
    end

    def create_instagram_customer(credentials)
      params = {
        :first_name => 'unfinished#instagram',
        :network_profiles_attributes => [get_network_profile_params(credentials)]
      }

      create_customer_by_params(params)
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
                :gender => credentials['extra']['raw_info']['gender'].to_gender!,
                :network_profiles_attributes => [get_network_profile_params(credentials)]
                }

      params.merge!(get_location(credentials['info']['location']))
      params
    end

    def get_location(full_location)
      if full_location && !full_location.empty?
        location = full_location.split(', ')

        {:city => location[0], :country => location[1]}
      else
        {}
      end
    end

    def get_date(date)
      begin
        Date.parse(date)
      rescue
        nil
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
              when 'vkontakte'
                {
                  :social_network => SocialNetwork.find_by(name: 'vkontakte'),
                  :access_token => credentials['credentials']['token'],
                  :expiration_date => credentials['credentials']['expires_at'].to_i.seconds.from_now,
                  :url => credentials['info']['urls']['Vkontakte'],
                  :uid => credentials['uid']
                }
              when 'instagram'
                {
                  :social_network => SocialNetwork.find_by(name: 'instagram'),
                  :access_token => credentials['credentials']['token'],
                  :expiration_date => "#{credentials['credentials']['expires'] ? credentials['credentials']['expires'] : '10000000000'}".to_i.seconds.from_now,
                  :url => "https://instagram.com/#{credentials['info']['nickname']}/",
                  :uid => credentials['uid']
                }
              end
    end
end
