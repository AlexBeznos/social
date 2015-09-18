class Answer < ActiveRecord::Base
  belongs_to :poll
  validates :poll_id, :content, :selects, presence: true
end
