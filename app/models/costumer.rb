class Costumer < ActiveRecord::Base
  enum network: [:vk, :facebook, :twitter, :instagram]

  validates :name, :url, :uid, :friends_count, presence: true, if: 'network.to_sym == :twitter'
end