class Customer::NetworkProfile < ActiveRecord::Base
  has_many :visits, :class_name => 'Customer::Visit',
                    :foreign_key => :customer_network_profile_id,
                    :dependent => :destroy

  belongs_to :customer
  belongs_to :social_network

  validates :uid, uniqueness: { scope: :social_network }
  validates :url, format: { with: /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix,
                            message: I18n.t('errors.wrong_link_format')}
  before_save :set_friends_count


  def set_friends_count
    self.friends_count = case social_network.name
                         when 'facebook'
                           FacebookService.get_friends_number(self)
                         when 'vkontakte'
                           VkService.get_friends_number(self)
                         end
  end
end
