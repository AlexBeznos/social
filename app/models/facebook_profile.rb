class FacebookProfile < ActiveRecord::Base
  require 'ext/string'

  has_one :profile, as: :resource
  has_many :visits, as: :account, class_name: "Customer::Visit"

  validates :uid, presence: true

  def self.prepare_params(credentials)
    {
      first_name: credentials['info']['first_name'],
      last_name: credentials['info']['last_name'],
      gender: credentials['extra']['raw_info']['gender'].to_gender!,
      friends_count: FacebookService.get_friends_number(credentials['credentials']['token']),
      url: credentials['info']['urls']['Facebook'],
      uid: credentials['uid'],
      access_token: credentials['credentials']['token'],
      expiration_date: Time.now + credentials['credentials']['expires_at'].to_i.seconds
    }
  end
end
