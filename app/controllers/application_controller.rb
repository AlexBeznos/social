class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  helper_method :current_user_session, :current_user
  protect_from_forgery with: :exception
  layout 'lumen'


  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def gen_root_path
      if current_user
        if current_user.general?
          return root_path
        elsif current_user.admin?
          return adm_root_path
        end
      else
        login_path
      end
    end
end
