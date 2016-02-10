class StockPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.franchisee?||user.general?
          scope.all
      end
    end
  end

  def permitted_attributes
    [:url, :image, :day]
  end

end
