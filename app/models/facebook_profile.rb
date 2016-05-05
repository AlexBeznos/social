class FacebookProfile < ActiveRecord::Base
  require 'ext/string'

  has_one :profile, as: :resource
  has_many :visits, as: :account, class_name: "Customer::Visit"

  validates :uid, presence: true

  after_commit :set_friends_number, on: :save

  def self.prepare_params(credentials)
    {
      first_name: credentials['info']['first_name'],
      last_name: credentials['info']['last_name'],
      gender: credentials['extra']['raw_info']['gender'].try(:to_gender!),
      url: credentials['info']['urls']['Facebook'],
      uid: credentials['uid'],
      access_token: credentials['credentials']['token'],
      expiration_date: Time.now + credentials['credentials']['expires_at'].to_i.seconds
    }
  end

  private

  def set_friends_number
    FriendsPullWorker.perform_async(self.class, id)
  end
end
