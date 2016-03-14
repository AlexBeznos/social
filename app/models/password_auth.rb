class PasswordAuth < ActiveRecord::Base
  NAME = Auth::ALTERNATIVE[:password]

  has_one :auth, as: :resource

  validates :password, presence: true
end
