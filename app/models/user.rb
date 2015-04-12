class User < ActiveRecord::Base
  acts_as_authentic

  enum group: [:general, :admin]
end
