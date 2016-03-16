class Notification < ActiveRecord::Base
  belongs_to :user, -> { where(group: "franchisee") }
  belongs_to :source, polymorphic: true

  validates :source_type, presence: true
  validates :category, presence: true
end
