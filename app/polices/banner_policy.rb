class BannerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.franchisee?||user.general?
          scope.all
      end
    end
  end

  def create? user.franchisee?||user.general?; end
  def read? user.franchisee?||user.general?; end
  def update? user.franchisee?||user.general?; end
  def destroy? user.franchisee?||user.general?; end

  def permitted_attributes
    [:name , :content]
  end
end
