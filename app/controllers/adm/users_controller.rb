class Adm::UsersController < AdministrationController
  before_action :set_user, except:[:index, :create, :new]

  after_action :verify_policy_scoped, only:[:index]
  after_action :verify_authorized

  def index
    authorize User

    @users = policy_scope(User)
  end

  def show
    authorize @user
  end

  def new
    authorize User

    @user = User.new
  end

  def create
    authorize User

    @user = User.new(permitted_attributes(User, true))

    if @user.save
      redirect_to adm_users_path, :notice => 'User created!'
    else
      render :action => :new, :alert => "U pass something wrong. Errors: #{@user.errors}"
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user

    if @user.update(permitted_attributes(User, true))
      redirect_to adm_users_path, :notice => 'User updated!'
    else
      render :action => :edit, :alert => "U pass something wrong. Errors: #{@user.errors}"
    end
  end

  def edit_password
    authorize @user, :edit?
  end

  def update_password
    authorize @user, :update?

    if @user.update(permitted_attributes(User, true))
      redirect_to adm_users_path, :notice => 'User updated!'
    else
      render :action => :new, :alert => "U pass something wrong. Errors: #{@user.errors}"
    end
  end

  def destroy
    authorize @user

    @user.destroy
    redirect_to adm_users_path, :notice => 'User destroyed!'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
