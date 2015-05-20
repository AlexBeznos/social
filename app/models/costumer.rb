class Costumer < ActiveRecord::Base
  belongs_to :social_network

  validates :name, :url, :uid, :friends_count, presence: true, if: 'social_network_id == 4' # if network is twitter
end
