class Adm::DashboardController < AdministrationController

  def index
    @users = User.all
    authorize! :show, @users
  end
end
