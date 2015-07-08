class UsersController < ApplicationController
  before_action :find_user, except: [:index, :new, :create]

  def index
    @users = current_user.place_owners
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = current_user.place_owners.new(user_params)
    @user.user_id = current_user.id

    if @user.save
      redirect_to users_path, :notice => I18n.t('models.users.created')
    else
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), :notice => I18n.t('models.users.updated')
    else
      render :action => :new
    end
  end


  def destroy
    @user.destroy
    redirect_to users_path
  end

  private
    # def require_franchisee
    #   if !current_user
    #     no_access_to_login
    #   elsif ![:franchisee, :admin].include?(current_user.group.to_sym)
    #     no_access_to_place
    #   end
    # end

    def find_user
      @user = User.find(params[:id])
    end

    # def require_proper_franchisee
    #   if @user != current_user && !current_user.place_owners.include?(@user)
    #     redirect_to users_path, alert: 'You have no rights to access this page!'
    #   end
    # end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :phone, :password, :password_confirmation)
    end
end
