class PlaceGroupPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.franchisee?
        scope.where(user_id: user_ids)
      elsif user.general? && user.id
        scope.where(user: user)
      elsif user.admin?
        scope.all
      end
    end
  end

  def permitted_attributes
    [:name, :user_id]
  end

end
