class Customer::Session < ActiveRecord::Base
  belongs_to :profile
  belongs_to :customer
end
