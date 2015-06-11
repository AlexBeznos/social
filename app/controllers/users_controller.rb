class UsersController < ApplicationController
  before_filter :require_franchisee
  before_action :find_user, except: [:index, :new, :create]
  before_filter :require_proper_franchisee, except: [:index, :new, :create]

  def index
    @users = current_user.place_owners
  end

  def show
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end

  private
    def require_franchisee
      if !current_user
        no_access_to_login
      elsif ![:franchisee, :admin].include?(current_user.group.to_sym)
        no_access_to_place
      end
    end

    def find_user
      @user = User.find(params[:id])
    end

    def require_proper_franchisee
      unless current_user.place_owners.include?(@user) || @user == current_user
        redirect_to users_path, alert: 'You have no rights to access this page!'
      end
    end
end
