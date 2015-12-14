class Ability
  include CanCan::Ability

  PLACE_ADDITIONAL_ACTINS = [
    :settings,
    :guests,
    :birthdays
  ]

  PLACE_RELATED_MODELS = [
    Stock,
    Style,
    Poll,
    MenuItem,
    Banner
  ]

  def initialize(user)
    user ||= User.new

    alias_action :create, :read, :update, :destroy, :to => :crud

    if user.admin?
      can :manage, :all
    elsif user.franchisee?
      user_ids = user.place_owners.map(&:id)
      all_user_ids = [user.id] + user_ids

      can :create, PlaceGroup
      can [:read, :update, :destroy], PlaceGroup, user_id: user_ids
      can :crud, User, id: user_ids + [user.id]
      cannot :destroy, User
      can [:crud] + PLACE_ADDITIONAL_ACTINS, Place, user_id: all_user_ids
      can :download_settings, Place, user_id: all_user_ids
      can :crud, PLACE_RELATED_MODELS
      can :crud, Message
    elsif user.id && user.general?
      can :crud, PlaceGroup, user: user
      can [:show, :update], User, id: user.id
      can [:crud] + PLACE_ADDITIONAL_ACTINS, Place, user: user
      cannot [:create, :destroy], Place
      can :crud, PLACE_RELATED_MODELS
      can :crud, Message, with_message_type: 'Place'
    else
      cannot :all, Place
    end
  end
end
