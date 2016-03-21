class NotificationPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if user.franchisee?
        scope.where( user_id: user.id )
      elsif user.admin?
        scope.all
      end
    end
  end

end
