class Customer < ActiveRecord::Base
  has_many :visits, dependent: :destroy, class_name: 'Customer::Visit'
  has_many :reputations, dependent: :destroy, class_name: 'Customer::Reputation'
  has_many :orders, dependent: :destroy
  has_many :profiles, dependent: :destroy
  has_many :ahoy_visits
end
