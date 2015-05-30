class Costumer < ActiveRecord::Base
  belongs_to :social_network

  before_validation :set_friends_count, if: 'social_network_id == 2'

  validates :uid, uniqueness: { scope: :social_network }
  validates :first_name, :url, :uid, :friends_count, :social_network, presence: true

  def set_friends_count
    self.friends_count = FacebookService.get_friends_number(self)
  end
end
