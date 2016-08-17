class AdvisorAuth < ActiveRecord::Base
  NAME = Auth::ALTERNATIVE[:advisor]

  has_one :auth, as: :resource
end
