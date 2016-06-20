class Device < ActiveRecord::Base
  has_and_belongs_to_many :customers
  validates :mac_address, presence: true
end
