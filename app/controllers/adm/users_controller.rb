class Adm::UsersController < AdministrationController
  load_and_authorize_resource :user

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to adm_users_path, :notice => 'User created!'
    else
      render :action => :new, :alert => "U pass something wrong. Errors: #{@user.errors}"
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to adm_users_path, :notice => 'User updated!'
    else
      render :action => :edit, :alert => "U pass something wrong. Errors: #{@user.errors}"
    end
  end

  def edit_password
  end

  def update_password
    if @user.update(user_params)
      redirect_to adm_users_path, :notice => 'User updated!'
    else
      render :action => :new, :alert => "U pass something wrong. Errors: #{@user.errors}"
    end
  end

  def destroy
    @user.destroy
    redirect_to adm_users_path, :notice => 'User destroyed!'
  end

  private
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :phone, :password, :password_confirmation, :group)
  end
end
