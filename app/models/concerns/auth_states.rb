module AuthStates
  include AASM

  def mark_as_unapproved!(current_user)

  end

  def mark_as_approved!(current_user)

  end

  aasm do
    state :pending
    state :unapproved
    state :approved, initial: true

    event :approve do
      transitions from: :pending, to: :approved
    end

    event :unapprove, after: :notify_owner do
      transitions from: :pending, to: :unapproved
    end

    event :modify, after: :notify_franchisee do

      transitions from: :unapproved, to: :pending
      transitions from: :approved, to: :pending
    end

  end

  private

  def notify_owner

  end

  def notify_franchisee

  end

  def create_nofication(category)


  end
end
