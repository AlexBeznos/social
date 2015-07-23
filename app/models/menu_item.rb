class MenuItem < ActiveRecord::Base
  belongs_to :place
  has_and_belongs_to_many :customers

  validates :name, :price, :place_id, presence: true
end
