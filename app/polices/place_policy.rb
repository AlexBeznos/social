class PlacePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.franchisee?
        scope.where(user_id: all_user_ids)
      elsif user.general? && user.id
        scope.where(user: user)
      else
        super
      end
    end
  end

  def settings? user.franchisee?||user.general?; end
  def guests? user.franchisee?||user.general?; end
  def birthdays? user.franchisee?||user.general?; end
  def download_settings? user.franchisee?; end
  def new? user.franchisee?; end
  def create? user.franchisee?; end
  def destroy? user.franchisee?; end

end
