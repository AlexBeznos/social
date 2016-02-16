class PlacePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.franchisee?
        scope.where(user_id: all_user_ids).find_by(:slug)
      elsif user.general? && user.id
        scope.where(user: user).find_by(:slug)
      else
        super
      end
    end
  end

  def settings?; user.franchisee?||user.general?||user.admin?; end
  def guests?; user.franchisee?||user.general?||user.admin?; end
  def birthdays?; user.franchisee?||user.general?||user.admin?; end
  def download_settings?; user.franchisee?||user.admin?; end
  def new?; user.franchisee?||user.admin?; end
  def create?; user.franchisee?||user.admin?; end
  def destroy?; user.franchisee?||user.admin?; end

  def permitted_attributes
     [:name,
      :logo,
      :slug,
      :enter_by_password,
      :password,
      :active,
      :redirect_url,
      :user_id,
      :stocks_active,
      :polls_active,
      :reputation_on,
      :simple_enter,
      :score_amount,
      :city,
      :display_other_banners,
      :display_my_banners,
      :loyalty_program,
      :domen_url,
      :sms_auth,
      :place_group_id,
      :auth_default_lang ]
  end

end