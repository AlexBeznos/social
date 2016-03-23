class PasswordProfile < ActiveRecord::Base
  has_one :profile, as: :resource
end
