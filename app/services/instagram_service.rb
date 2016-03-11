class InstagramService # NOTICE: Refactore class to general style in case of using
  attr_accessor :hash

  def initialize(hash)
    @place = hash[:place]
    @message = hash[:message]
    @credentials = hash[:credentials]
  end

  def self.get_user_id(user_name)
    Instagram.user_search(user_name, :count => 1).first['id']
  end

  def self.get_more_customer_info(customer)
    network_profile = customer.network_profiles
                              .where({:social_network => SocialNetwork.select(:id).find_by(name: 'vkontakte')})
                              .first

    user = get_user network_profile
    full_name = user['full_name'].split(' ')

    unless full_name.empty?
      { first_name: full_name[0], last_name: full_name[1] }
    else
      { first_name: user['username'] }
    end
  end

  def self.get_friends_number(customer)
    user = get_user customer
    user['counts']['followed_by']
  end

  def advertise
    client = Instagram.client(:access_token => @credentials['credentials']['token'])

    begin
      client.follow_user(@message.subscription_uid)
    rescue => e
      Rails.logger.fatal "Twitter message was not posted. Error: #{e}"
    end
  end

  private
    def self.get_user(network_profile)
      client = Instagram.client(:access_token => network_profile.access_token)
      client.user
    end
end
