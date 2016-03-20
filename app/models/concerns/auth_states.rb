module AuthStates
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm do
      state :pending
      state :unapproved
      state :approved, initial: true

      event :approve do
        transitions from: :pending, to: :approved
      end

      event :unapprove do
        transitions from: :pending, to: :unapproved
      end

      event :modify do
        transitions from: [:unapproved, :approved], to: :pending
      end
    end
  end
  
end
