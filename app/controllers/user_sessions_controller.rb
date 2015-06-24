class UserSessionsController < ApplicationController
  before_filter :redirect_user, except: :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to gen_root_path(@user_session.user)
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to login_path
  end

  private
    def redirect_user
      if current_user
        redirect_to gen_root_path
      end
    end
end
