class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, polymorphic: true

  enum category: [:unapproved_authentication]
end
