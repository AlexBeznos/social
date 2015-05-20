class SocialNetwork < ActiveRecord::Base
  has_many :messages
  has_many :consumers

  validates :name, :presence => true, :uniqueness => true
end
