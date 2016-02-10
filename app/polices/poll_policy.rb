class PollPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.franchisee?||user.general?
          scope.all
      end
    end
  end

  def permitted_attributes
    [:question,
     answers_attributes:
        [:id,
         :content,
         :_destroy]]
  end
end
