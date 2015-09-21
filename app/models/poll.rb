class Poll < ActiveRecord::Base
	belongs_to :place
	has_many :answers, :dependent => :destroy
  accepts_nested_attributes_for :answers
  validates_presence_of :place
end
