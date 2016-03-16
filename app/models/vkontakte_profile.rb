class VkontakteProfile < ActiveRecord::Base
  has_one :profile, as: :resource
end
