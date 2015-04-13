class Adm::DashboardController < AdministrationController
  def index
    @users = User.all
  end
end
