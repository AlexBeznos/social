class AhoyVisit < ActiveRecord::Base
  belongs_to :customer
  belongs_to :place
  has_many :ahoy_events, class_name: "Ahoy::Event"
end
