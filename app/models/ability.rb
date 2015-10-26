class Ability
  include CanCan::Ability

  PLACE_ADDITIONAL_ACTINS = [
    :settings,
    :guests,
    :birthdays
  ]

  PLACE_RELATED_MODELS = [
    Stock,
    Message,
    Style,
    Poll,
    MenuItem
  ]

  def initialize(user)
    user ||= User.new

    alias_action :create, :read, :update, :destroy, :to => :crud

    if user.admin?
      can :manage, :all
    elsif user.franchisee?
      user_ids = user.place_owners.map(&:id)
      all_user_ids = [user.id] + user_ids

      can :crud, User, id: user_ids + [user.id]
      cannot :destroy, User
      can [:crud] + PLACE_ADDITIONAL_ACTINS, Place, user_id: all_user_ids
      can :download_settings, Place, user_id: all_user_ids
      can :crud, PLACE_RELATED_MODELS
    elsif user.id && user.general?
      can [:show, :update], User, id: user.id
      can [:crud] + PLACE_ADDITIONAL_ACTINS, Place, user: user
      cannot [:create, :destroy], Place
      can :crud, PLACE_RELATED_MODELS
    else
      cannot :all, Place
    end
  end
end
