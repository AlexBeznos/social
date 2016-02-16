class Adm::DashboardController < AdministrationController

  def index
    authorize User
    @users = User.all
  end
end
