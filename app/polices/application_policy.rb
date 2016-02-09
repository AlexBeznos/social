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

  def initialize (user,record)
    raise Pundit::NotAuthorizedError , "You must be authorized" unless user
    @user = user
    @record = record
  end

  def index?    ; user.franchisee?||user.general?||user.admin?; end
  def new?      ; user.franchisee?||user.general?||user.admin?; end
  def edit?     ; user.franchisee?||user.general?||user.admin?; end
  def create?   ; user.franchisee?||user.general?||user.admin?; end
  def show?     ; user.franchisee?||user.general?||user.admin?; end
  def update?   ; user.franchisee?||user.general?||user.admin?; end
  def destroy?  ; user.franchisee?||user.general?||user.admin?; end

  private

  def all_user_ids
    [user.id] + user_ids
  end

  def user_ids
    user.place_owners.map(&:id)
  end

end
