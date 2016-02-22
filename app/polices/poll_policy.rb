class PollPolicy < ApplicationPolicy


  def permitted_attributes
    [
      :question,
      answers_attributes: [
        :id,
        :content,
        :_destroy
      ]
    ]
  end
end
