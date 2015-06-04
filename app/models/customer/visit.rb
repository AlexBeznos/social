class Customer::Visit < ActiveRecord::Base
  default_scope { order('created_at DESC') }

  scope :by_date, lambda {|date| where("customer_visits.created_at >= ?", date) }
  scope :by_gender, lambda {|gender = 'f'| where('customers.gender = ?', gender == 'm' ? 'male' : 'female') }

  belongs_to :customer
  belongs_to :place
  belongs_to :network_profile,  :class_name => 'Customer::NetworkProfile',
                                :foreign_key => :customer_network_profile_id

  validate :network_profile, :place, :created_at, presence: true, unless: 'by_password'
end
