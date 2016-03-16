class FacebookProfile < ActiveRecord::Base
  has_one :profile, as: :resource

  accepts_nested_attributes_for :profile

  def set_friends_count
    self.friends_count = "#{social_network.name.capitalize}Service".constantize.get_friends_number(self)
  end
end
