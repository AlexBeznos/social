class Answer < ActiveRecord::Base
  belongs_to :poll
  # validates :poll_id, :content, :number_of_selections, presence: true 
  # for unknown reasons neither of this validations work properly
  attr_accessor :number_of_selections
end
