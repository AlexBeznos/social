class User < ActiveRecord::Base
  acts_as_authentic
  has_many :places

  enum group: [:general, :admin]
end
