class Customer::Session < ActiveRecord::Base
  extend ConditionQueries
  belongs_to :profile
  belongs_to :customer




end
