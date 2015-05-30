class SocialNetwork < ActiveRecord::Base
  has_many :messages
  has_many :customers

  validates :name, :presence => true, :uniqueness => true
end
