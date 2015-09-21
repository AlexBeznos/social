class Poll < ActiveRecord::Base
	belongs_to :place
	has_many :answers, :dependent => :destroy
  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  validates :place_id, :question, presence: true 
end
