class Customer::Visit < ActiveRecord::Base
  belongs_to :network_profile, :class_name => 'Customer::NetworkProfile'
  belongs_to :place

  validate :network_profile, :place, :created_at, presence: true
end
