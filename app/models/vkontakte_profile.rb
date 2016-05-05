class VkontakteProfile < ActiveRecord::Base
  require 'ext/string'

  has_one :profile, as: :resource
  has_many :visits, as: :account, class_name: "Customer::Visit"

  after_commit :set_friends_number, on: [:create, :update]

  def self.prepare_params(credentials)
    {
      first_name: credentials['extra']['raw_info']['first_name'],
      last_name: credentials['extra']['raw_info']['last_name'],
      gender: credentials['extra']['raw_info']['sex'].to_s.try(:to_gender!),
      birthday: Profile.prepare_date(credentials['extra']['raw_info']['bdate']),
      access_token: credentials['credentials']['token'],
      expiration_date: credentials['credentials']['expires_at'].to_i.seconds.from_now,
      url: credentials['info']['urls']['Vkontakte'],
      uid: credentials['uid']
    }
  end

  private

  def set_friends_number
    FriendsPullWorker.perform_async(self.class, id)
  end
end
