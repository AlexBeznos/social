class Customer::NetworkProfile < ActiveRecord::Base
  has_many :visits, class_name: 'Customer::Visit',
                    foreign_key: :customer_network_profile_id,
                    dependent: :destroy

  belongs_to :customer
  belongs_to :social_network

  validates :uid, uniqueness: { scope: :social_network_id }
  validates :url, url: true
  before_save :set_friends_count, unless: :friends_count
  before_save :set_name_for_customer, if: -> (r) { r.social_network.name == 'instagram' }


  def set_friends_count
    self.friends_count = "#{social_network.name.capitalize}Service".constantize.get_friends_number(self)
  end

  def set_name_for_customer
    name = InstagramService.get_user_name(self)
    self.customer.update(first_name: name)
  end
end
