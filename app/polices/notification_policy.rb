class NotificationPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.where( user_id: user.id )
    end
  end

  def approve?
    user.franchisee? || user.admin?
  end

  def unapprove?
    user.franchisee? || user.admin?
  end

end
