class GlobalStatisticsPolicy < Struct.new(:user, :global_statistics)
  def visits_index?
    user.admin?
  end
end
