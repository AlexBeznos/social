class MenuItem < ActiveRecord::Base
  belongs_to :place

  validates :name, :price, :place_id, presence: true
end
