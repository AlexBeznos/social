class Device < ActiveRecord::Base
  validates :mac_address, presence: true
end
