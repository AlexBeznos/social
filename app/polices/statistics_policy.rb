class StatisticsPolicy < Struct.new(:user, :statistics)
  def visits_index?
    user.admin?
  end
end
