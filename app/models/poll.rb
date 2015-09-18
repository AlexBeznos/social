class Poll < ActiveRecord::Base
  belongs_to :user
  has_many :answers, :dependent => :destroy
  validates :user_id, :question, presence: true
  validates :answers_number, presence: true, :inclusion => { :in => 2..10,
  			message: "Poll must have 2..10 answers" } 
end
