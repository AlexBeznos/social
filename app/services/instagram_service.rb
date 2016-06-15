class InstagramService

  def initialize(hash)
    @place = hash[:place]
    @message = hash[:message]
    @profile = hash[:profile]
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

  def advertise
  end
end
