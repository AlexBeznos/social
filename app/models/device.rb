class Device < ActiveRecord::Base
  include ConditionalQueries

  validates :mac_address, presence: true
end
