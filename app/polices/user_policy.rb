class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.franchisee?
        scope.where(id: user_ids + [user.id])
      elsif user.general? && user.id
        scope.where(id: user.id)
      elsif user.admin?
        scope.all
      end
    end
  end

  def destroy?; user.franchisee?||user.admin?; end
  def create?; user.franchisee?||user.admin?; end

  def permitted_attributes
    [:email,
     :first_name,
     :last_name,
     :phone,
     :timezone,
     :password,
     :password_confirmation]
  end
end
