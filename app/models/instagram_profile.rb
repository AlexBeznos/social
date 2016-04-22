class InstagramProfile < ActiveRecord::Base
  has_one :profile, as: :resource
  has_many :visits, as: :account, class_name: "Customer::Visit"

  validates :uid, presence: true

  def self.prepare_params(credentials)
    nickname = credentials['info']['nickname']

    {
      name: credentials['info']['name'],
      nickname: nickname,
      url: "http://instagram.com/#{nickname}",
      uid: credentials['uid'],
      access_token: credentials['credentials']['token']
    }
  end
end
