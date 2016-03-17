class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, polymorphic: true

  validates :category, presence: true
end
