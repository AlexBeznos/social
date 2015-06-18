class Customer::Visit < ActiveRecord::Base
  default_scope { order('created_at DESC') }

  scope :by_date, lambda {|date| where(created_at: date..date.end_of_day) }
  scope :by_date_from_to, lambda {|from, to| where(created_at: from..to.end_of_day) }
  scope :by_gender, lambda {|gender = 'f'| where('customers.gender = ?', gender == 'm' ? 'male' : 'female') }

  belongs_to :customer
  belongs_to :place
  belongs_to :network_profile,  :class_name => 'Customer::NetworkProfile',
                                :foreign_key => :customer_network_profile_id

  validate :network_profile, :place, :created_at, presence: true, unless: 'by_password'


end
