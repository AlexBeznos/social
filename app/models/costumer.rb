class Costumer < ActiveRecord::Base
  belongs_to :social_network

  validates :uid, uniqueness: { scope: :social_network }
  validates :name, :url, :uid, :friends_count, :social_network, presence: true
end
