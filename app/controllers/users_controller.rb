class UsersController < ApplicationController
  # load_and_authorize_resource :user, except: [:new, :create]
  before_action :set_user , except: [:index , :new , :create]
  after_action :verify_policy_scoped , only:[ :index ]
  after_action :verify_authorized


  def index
    authorize User
    @users = policy_scope(User)
  end

  def show
    authorize @user
    policy_scope(User)
  end

  def new
    authorize User
    @user = User.new
  end

  def create
    authorize User
    @user = current_user.place_owners.new(permitted_attributes(User))
    @user.user_id = current_user.id

    if @user.save
      redirect_to users_path, :notice => I18n.t('models.users.created')
    else
      render :action => :new
    end

  end

  def edit
    if policy_scope(User).include?(@user)
      authorize @user
    end
  end

  def update
    authorize @user
    if policy_scope(User).include?(@user) && @user.update(permitted_attributes(@user))
      redirect_to user_path(@user), :notice => I18n.t('models.users.updated')
    else
      render :action => :edit
    end
  end


  def destroy
    authorize @user
    if policy_scope(User).include?(@user)
      @user.destroy
      redirect_to users_path
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end
end
