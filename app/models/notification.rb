class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, polymorphic: true, dependent: :destroy

  validates :source_type, presence: true
  validates :category, presence: true
end
