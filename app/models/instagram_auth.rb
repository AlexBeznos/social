class InstagramAuth < ActiveRecord::Base
  NAME = Auth::NETWORKS[:instagram]

  has_one :auth, as: :resource
end
