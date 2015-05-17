class AdministrationController < ApplicationController
  layout 'admin'
  before_action :require_admin

  private
    def require_admin
      unless current_user && current_user.admin?
        redirect_to login_path, alert: 'You should to be admin to access this page!'
      end
    end
end
