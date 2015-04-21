class User < ActiveRecord::Base
  acts_as_authentic
  has_many :places, :dependent => :destroy

  enum group: [:general, :admin]
end
