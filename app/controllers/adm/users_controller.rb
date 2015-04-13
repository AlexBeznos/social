class Adm::UsersController < AdministrationController
  before_filter :find_user, except: [:index, :new, :create]
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
      render :action => :new, :alert => "U pass something wrong. Errors: #{@user.errors}"
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
    redirect_to adm_users_path, :notice => 'User destroied!'
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :group)
  end

  def find_user
    @user = User.find(params[:id])
  end
end
