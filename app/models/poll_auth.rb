class PollAuth < ActiveRecord::Base
  NAME = Auth::ALTERNATIVE[:poll]

  has_one :auth, as: :resource
  has_many :answers, dependent: :destroy
  validates :poll_auth_id, :question, presence: true

  accepts_nested_attributes_for :answers, reject_if: lambda { |a| a[:content].blank? }, allow_destroy: true

end
