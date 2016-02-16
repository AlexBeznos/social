class AdministrationController < ApplicationController
  layout 'admin'

  after_action :verify_authorized

  before_action :verify_user_role

  private

  def verify_user_role
    if current_user && current_user.admin?
      raise Pundit::NotAutnorizedError, "You`re not admin to perform this action"
  end

end
