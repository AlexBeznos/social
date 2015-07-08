class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    elsif user.franchisee?
      can :manage, [User, Place, Message, Stock]
    elsif user.general?
      can :read, [User, Place]
    end
  end
end
