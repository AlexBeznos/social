class ApplicationPolicy
  attr_reader :user , :record

  class Scope
    attr_reader :user , :scope

    def initialize(user,scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?||user.franchisee?||user.general?
        scope.all
      end
    end
  end





  def initialize (user,record)
    raise Pundit::NotAuthorizedError , "You must be authorized" unless user
    @user = user
    @record = record
  end

  def index?    ; everyone; end
  def new?      ; everyone; end
  def edit?     ; everyone; end
  def create?   ; everyone; end
  def show?     ; everyone; end
  def update?   ; everyone; end
  def destroy?  ; everyone; end

  private

  def all_user_ids
    [user.id] + user_ids
  end

  def user_ids
    user.place_owners.map(&:id)
  end

  def everyone
    user.franchisee?||user.general?||user.admin?;
  end

end
