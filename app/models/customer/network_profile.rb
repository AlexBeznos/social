class Customer::NetworkProfile < ActiveRecord::Base
  belongs_to :customer
  belongs_to :social_network

  before_validation :set_friends_count, if: 'social_network_id == 2'

  validates :uid, uniqueness: { scope: :social_network }

  def set_friends_count
    self.friends_count = FacebookService.get_friends_number(self)
  end
end
