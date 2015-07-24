class MenuItem < ActiveRecord::Base
  belongs_to :place
  has_many :orders
  has_many :customers, through: :orders

  validates :name, :price, :place_id, presence: true
end
