class Customer::NetworkProfile < ActiveRecord::Base
  has_many :visits, :class_name => 'Customer::Visit',
                    :foreign_key => :customer_network_profile_id,
                    :dependent => :destroy

  belongs_to :customer
  belongs_to :social_network

  validates :uid, uniqueness: { scope: :social_network }
  validates :url, :url => true
  before_save :set_friends_count


  def set_friends_count
    self.friends_count = case social_network.name
                         when 'facebook'
                           FacebookService.get_friends_number(self)
                         when 'vkontakte'
                           VkService.get_friends_number(self)
                         when 'instagram'
                           InstagramService.get_friends_number(self)
                         end
  end
end
