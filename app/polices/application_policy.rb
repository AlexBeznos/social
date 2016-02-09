class ApplicationPolicy
  class Scope
    attr_reader :user , :scope

    def initialize(user,scope)
      @user = user
      @scope = scope
    end

    def resolve
        scope.all if user.admin?
    end
  end



  attr_reader :user , :record

  #NOTE:monkey patch , works like a 'can :manage , :all' in cancancan gem
  def authorize(record,query=nil)
    if current_user.try(:is_admin)
      @_policy_authorized = true
    else
      super
    end
  end


  def initialize (user,record)
    raise Pundit::NotAuthorizedError , "You must be authorized" unless user
    @user = user
    @record = record
  end

  def index? user.franchisee?||user.general?; end
  def new? user.franchisee?||user.general?; end
  def edit? user.franchisee?||user.general?; end
  def create? user.franchisee?||user.general?; end
  def show? user.franchisee?||user.general?; end
  def update? user.franchisee?||user.general?; end
  def destroy? user.franchisee?||user.general?; end

  private

  def all_user_ids
    [user.id] + user_ids
  end

  def user_ids
    user.place_owners.map(&:id)
  end

end
