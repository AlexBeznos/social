class SocialNetworksServices < ActiveType::Object

  attribute :network, :string
  attribute :state, :string
  attribute :slug, :string
  attribute :credentials, :text

  def get_auth_path
    case self.network
    when 'vk'
      return "https://oauth.vk.com/authorize?client_id=#{ENV['VK_APP_ID']}&scope=wall&display=page&redirect_uri=#{ENV['APP_URL']}#{ENV['VK_REDIRECT_PATH']}&response_type=code&"
    when 'facebook'
      oauth = Koala::Facebook::OAuth.new(ENV['FB_APP_ID'], ENV['FB_SECRET'], ENV['APP_URL'] + ENV['FB_REDIRECT_PATH'])
      return oauth.url_for_oauth_code(:permissions => ['publish_stream', 'offline_access', 'manage_pages'], :state => self.state)
    when 'twitter'
      return "/auth/twitter/?place=#{self.slug}&state=#{self.state}"
    end
  end

  def post_message_and_get_url
    place = Place.find_by_slug(self.slug)
    case self.credentials['provider']
    when 'twitter'
      return TwitterService.new({:place => place, :credentials => self.credentials}).send_message
    end
  end

end
