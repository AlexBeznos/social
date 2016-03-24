class InstagramService
  def initialize(hash)
    @place = hash[:place]
    @message = hash[:message]
    @credentials = hash[:credentials]
  end

  def self.get_token(credentials)
    {
      'provider' => credentials['provider'],
      'token' => credentials['credentials']['token'],
      'uid' => credentials['uid']
    }
  end

  def self.get_user_name(network_profile)
    client = Instagram.client(access_token: network_profile.access_token)
    user = client.user

    user['full_name'].blank? ? user['username'] : user['full_name']
  end

  def self.get_friends_number(customer)
    # user = get_user customer
    # user['counts']['followed_by']
    0 # NOTE: for now it should be 0 because we do not post anything to instagram
  end

  def advertise
  end
end
