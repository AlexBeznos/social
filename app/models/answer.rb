class Answer < ActiveRecord::Base
  belongs_to :poll_auth
  # validates :poll_id, :content, :number_of_selections, presence: true
  # for unknown reasons neither of this validations work properly
end
