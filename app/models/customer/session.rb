class Customer::Session < ActiveRecord::Base
  include ConditionalQueries
  
  belongs_to :profile
  belongs_to :customer
end
