class AdministrationController < ApplicationController
  layout 'admin'
  before_action :require_admin

  private
    def require_admin
      unless current_user && current_user.admin?
        redirect_to gen_root_path, alert: 'You have no rights to access this page!'
      end
    end
end
