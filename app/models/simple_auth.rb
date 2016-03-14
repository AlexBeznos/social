class SimpleAuth < ActiveRecord::Base
  NAME = Auth::ALTERNATIVE[:simple]

  has_one :auth, as: :resource
end
