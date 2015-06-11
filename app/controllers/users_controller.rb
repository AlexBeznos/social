class UsersController < ApplicationController
  before_filter :require_franchisee

  def index
    @users = current_user.place_owners
  end

  def show
  end

  private
    def require_franchisee
      if !current_user
        no_access_to_login
      elsif ![:franchisee, :admin].include?(current_user.group.to_sym)
        no_access_to_place
      end
    end
end
