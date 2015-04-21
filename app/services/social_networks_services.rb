class SocialNetworksServices < ActiveType::Object
  attribute :network, :string
  attribute :state, :string

  def get_auth_path
    case self.network
    when 'vk'
      return "https://oauth.vk.com/authorize?client_id=#{ENV['VK_APP_ID']}&scope=wall&display=page&redirect_uri=#{ENV['APP_URL']}#{ENV['VK_REDIRECT_PATH']}&response_type=code&"
    when 'facebook'
      oauth = Koala::Facebook::OAuth.new(ENV['FB_APP_ID'], ENV['FB_SECRET'], ENV['APP_URL'] + ENV['FB_REDIRECT_PATH'])
      return oauth.url_for_oauth_code(:permissions => ['publish_stream', 'offline_access', 'manage_pages'], :state => self.state)
    end
  end
end
