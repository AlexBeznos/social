class StylePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.franchisee?||user.general?
          scope.all
      end
    end
  end

end
