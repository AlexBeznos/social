class ApplicationPolicy
  attr_reader :user, :record

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin? || user.franchisee? || user.general?
        scope.all
      end
    end

    protected

    def all_user_ids
      [user.id] + user_ids
    end

    def user_ids
      user.place_owners.pluck(:id)
    end

    def all_owners_places_ids
      Place.where(user_id: all_user_ids)
    end

  end

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, I18n.t('pundit.default') unless user
    @user = user
    @record = record


    if record && !record.is_a?(Class)
      unless self.class::Scope.new(user, record.class).resolve.include?(record)
        raise Pundit::NotAuthorizedError, I18n.t('pundit.default')
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

end
