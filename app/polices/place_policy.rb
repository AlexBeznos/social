class PlacePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.franchisee?
        scope.where(user_id: all_user_ids)
      elsif user.general? && user.id
        scope.where(user: user)
      elsif user.admin?
        scope.all
      end
    end
  end



  def new?; user.franchisee? || user.admin?; end
  def create?; user.franchisee? || user.admin?; end
  def destroy?; user.franchisee? || user.admin?; end
  def download_settings?; user.franchisee? || user.admin?; end
  def settings?; true; end
  def guests?; true; end
  def birthdays?; true; end

  def permitted_attributes
    [
      :name,
      :logo,
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
      :auth_default_lang,
      :ssid,
      :mfa
    ]
  end

end
