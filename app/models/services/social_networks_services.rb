class SocialNetworksServices < ActiveType::Object

  attribute :network, :string
  attribute :state, :string
  attribute :slug, :string
  attribute :credentials, :text

  def get_auth_path
    case self.network
    when 'vk'
      return "#{ENV['APP_URL']}auth/vkontakte/?state=#{self.state}"
    when 'facebook'
      oauth = Koala::Facebook::OAuth.new(ENV['FB_APP_ID'], ENV['FB_SECRET'], ENV['APP_URL'] + ENV['FB_REDIRECT_PATH'])
      return oauth.url_for_oauth_code(:permissions => ['publish_stream', 'offline_access', 'manage_pages'], :state => self.state)
    when 'twitter'
      return "#{ENV['APP_URL']}auth/twitter/?state=#{self.state}"
    when 'instagram'
      return "#{ENV['APP_URL']}auth/instagram?scope=relationships"
    end
  end

  def post_message_and_get_url
    place = Place.find_by_slug(self.slug)
    attrs = {:place => place, :credentials => self.credentials}

    return  case self.credentials['provider']
            when 'twitter'
               TwitterService.new(attrs).advertise
            when 'instagram'
               InstagramService.new(attrs).advertise
            when 'vkontakte'
               VkService.new(attrs).advertise
            end
  end

end
