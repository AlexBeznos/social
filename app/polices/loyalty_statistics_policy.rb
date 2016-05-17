class LoyaltyStatisticsPolicy < Struct.new(:user, :loyalty_statictics)
  def show?
    user.general?
  end
end
