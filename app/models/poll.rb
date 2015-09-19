class Poll < ActiveRecord::Base
	belongs_to :place
	has_many :answers, :dependent => :destroy
end
