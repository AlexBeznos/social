class Adm::DashboardController < AdministrationController

  def index
    authorize  User , :index?
    @users = User.all
  end
end
