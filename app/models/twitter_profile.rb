class TwitterProfile < ActiveRecord::Base
  has_one :profile, as: :resource

  def self.prepare_params(credentials)
    {
      name: credentials['info']['name'],
      url: credentials['info']['urls']['Twitter'],
      uid: credentials['uid'],
      access_token: credentials['credentials']['token'],
      access_token_secret: credentials['credentials']['secret'],
      expiration_date: Time.now + 1.year,
      friends_count: credentials['extra']['raw_info']['followers_count']
    }
  end
end
