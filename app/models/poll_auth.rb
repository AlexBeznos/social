class PollAuth < ActiveRecord::Base
	belongs_to :place
	has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers, allow_destroy: true, reject_if: lambda { |a| a[:content].blank? }

	validates :place_id, :question, presence: true

	def answers=(attributes, options = {})
		p '_+_+_+'
		p attributes
	end
end
