class Ability
  include CanCan::Ability

  PLACE_ADDITIONAL_ACTINS = [
    :settings,
    :guests,
    :birthdays
  ]

  def initialize(user)
    user ||= User.new

    alias_action :create, :read, :update, :destroy, :to => :crud

    if user.admin?
      can :manage, :all
    elsif user.franchisee?
      user_ids = user.place_owners.map(&:id)

      can :crud, User, id: user_ids + [user.id]
      cannot :destroy, User
      can [:crud] + PLACE_ADDITIONAL_ACTINS, Place, user_id: [user.id] + user_ids
      can :crud, [Stock, Message], :place => { :user_id => [user.id] + user_ids }
    elsif user.general?
      can [:show, :update], User, id: user.id
      can [:crud] + PLACE_ADDITIONAL_ACTINS, Place, user_id: user.id
      cannot [:create, :destroy], Place
      can :crud, [Stock, Message], :place => { :user => user }
    end
  end
end
