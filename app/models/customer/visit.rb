class Customer::Visit < ActiveRecord::Base
  belongs_to :place
  belongs_to :network_profile,  :class_name => 'Customer::NetworkProfile',
                                :foreign_key => 'customer_network_profile_id'

  validate :network_profile, :place, :created_at, presence: true, unless: 'by_password'
end
