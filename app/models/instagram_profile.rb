class InstagramProfile < ActiveRecord::Base
  has_one :profile, as: :resource

  validates :uid, presence: true

  def self.prepare_params(credentials)
    nickname = credentials['extra']['nickname']

    {
      name: credentials['extra']['name'],
      nickname: nickname,
      url: "http://instagram.com/#{nickname}",
      uid: credentials['extra']['uid'],
      token: credentials['token']
    }
  end
end
