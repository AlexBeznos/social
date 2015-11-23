class Category < ActiveRecord::Base
  has_many :places
  belongs_to :user
  validates :name, presence: true
end
