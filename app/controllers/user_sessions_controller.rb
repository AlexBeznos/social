class UserSessionsController < ApplicationController
  layout 'lumen'

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to gen_root_path
    else
      flash[:alert] = "Something went wrong. Errors: #{@user_session.errors.each {|e| e}}"
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to login_path
  end

end
