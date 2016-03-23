class VkontakteProfile < ActiveRecord::Base
  require 'ext/string'

  has_one :profile, as: :resource

  def self.prepare_params(credentials)
    {
      first_name: credentials['extra']['raw_info']['first_name'],
      last_name: credentials['extra']['raw_info']['last_name'],
      gender: credentials['extra']['raw_info']['sex'].to_s.to_gender!,
      birthday: Profile.prepare_date(credentials['extra']['raw_info']['bdate']),
      access_token: credentials['credentials']['token'],
      expiration_date: credentials['credentials']['expires_at'].to_i.seconds.from_now,
      url: credentials['info']['urls']['Vkontakte'],
      uid: credentials['uid'],
      friends_count: VkontakteService.get_friends_number(credentials['credentials']['token'])
    }
  end
end
