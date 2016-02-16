class Adm::DashboardController < AdministrationController

  def index
    authorize User
    @users = policy_scope(User)
  end
end
