class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.franchisee?
        scope.where(id: user_ids + [user.id])
      elsif user.general? && user.id
        scope.where(id: user.id)
      else
        super
      end
    end
  end

  def destroy? user.franchisee?; end
  def create? user.franchisee?; end
end
