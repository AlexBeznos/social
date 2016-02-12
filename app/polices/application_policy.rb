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

  def initialize (user, record)
    raise Pundit::NotAuthorizedError , "You must be authorized" unless user
    @user = user
    @record = record

    if record && !record.is_a?(Class)
      if !Scope.new(user, record.class).resolve.include?(record)
        p "----------------------------"
        p "OK"
        # raise Pundit::NotAuthorizedError ,"Scope Error"
      end
    end
  end

  def index?    ; true; end
  def new?      ; true; end
  def edit?     ; true; end
  def create?   ; true; end
  def show?     ; true; end
  def update?   ; true; end
  def destroy?  ; true; end

  private

  def all_user_ids
    [user.id] + user_ids
  end

  def user_ids
    user.place_owners.map(&:id)
  end

end
