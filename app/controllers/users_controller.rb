class UsersController < ApplicationController
  load_and_authorize_resource :user, except: [:new, :create]

  def index
    @users = current_user.place_owners
  end

  def show
  end

  def new
    @user = User.new
    authorize! :create, User
  end

  def create
    @user = current_user.place_owners.new(user_params)
    @user.user_id = current_user.id

    if @user.save
      redirect_to users_path, :notice => I18n.t('models.users.created')
    else
      render :action => :new
    end

    authorize! :create, @user
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), :notice => I18n.t('models.users.updated')
    else
      render :action => :edit
    end
  end


  def destroy
    @user.destroy
    redirect_to users_path
  end

  private

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :phone, :timezone, :password, :password_confirmation)
    end
end
