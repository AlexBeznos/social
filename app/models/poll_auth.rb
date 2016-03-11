class PollAuth < ActiveRecord::Base
  NAME = Auth::ALTERNATIVE[:poll]

  has_one :auth, as: :resource
  has_many :answers, dependent: :destroy
  validates :question, presence: true

  accepts_nested_attributes_for :answers, reject_if: lambda { |a| a[:content].blank? }, allow_destroy: true

  def answers_attributes=(attributes, options = {})
    remove_redundant_answers(attributes)
    super attributes.select { |k,v| v[:content] }
  end

  private
  def remove_redundant_answers(attributes)
    ids = attributes.select { |k, v| v.include?(:id) && !v.include?(:content) }
                    .map    { |k, v| v[:id] }

    answers.where(id: ids).destroy_all
  end
end
