class Answer < ActiveRecord::Base
  belongs_to :poll
  validates_presence_of :poll
end
