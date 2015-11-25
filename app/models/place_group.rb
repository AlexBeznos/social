class PlaceGroup < ActiveRecord::Base
  has_many :messages, as: :with_message, :dependent => :destroy
  has_many :places
  belongs_to :user
  validates :name, presence: true
end
