class Auth < ActiveRecord::Base
  include AASM

  NETWORKS = {
    vkontakte: 'vkontakte',
    facebook: 'facebook',
    twitter: 'twitter'
  }

  ALTERNATIVE = {
    poll: 'poll',
    sms: 'sms',
    password: 'password',
    simple: 'simple'
  }

  METHODS = NETWORKS.values + ALTERNATIVE.values

  enum step: %i( primary secondary )

  scope :active, -> { where(active: true) }
  scope :resource_like, -> (meth) { where("resource_type LIKE ?", "#{meth}%") }

  has_one :notification, as: :source, dependent: :destroy
  belongs_to :place
  belongs_to :resource, polymorphic: true, dependent: :destroy

  validates :redirect_url, presence: true, url: true
  validates :resource_type, uniqueness: {
    conditions: -> { where(active: true) },
    scope: [ :place_id, :step ]
  }, unless: -> (r) { r.resource_type == PollAuth }

  accepts_nested_attributes_for :resource

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

  def mark_as_modified!
    if NETWORKS.keys.include? name
        create_notification(
          category: :modified_authentication,
          user: place.user.franchisee
        )
        modify!
    end
  end

  def resource_attributes=(attributes, options = {})
    if persisted?
      super attributes
    else
      self.resource = resource_type.constantize.new(attributes, options)
    end
  end


  def auth_methods
    persisted? ? [resource.class::NAME] : Auth::METHODS
  end

  def name
    resource.class::NAME.to_sym
  end

end
