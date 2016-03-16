class NotificationPolicy < ApplicationPolicy

  def destroy?; user.admin? || user.franchisee? end

end
