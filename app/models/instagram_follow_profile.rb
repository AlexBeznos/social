class InstagramFollowProfile < ActiveRecord::Base
  has_one :profile, as: :resource
  has_many :visits, as: :account, class_name: "Customer::Visit"

  def self.prepare_params(params)
  end
end
