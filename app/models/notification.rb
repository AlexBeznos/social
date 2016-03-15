class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, polymorphic: true

  validates :source_type, presence: true
  validates :name, presence: true
end
