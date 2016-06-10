class Auth < ActiveRecord::Base
  include AASM

  NETWORKS = {
    vkontakte: 'vkontakte',
    facebook: 'facebook',
    twitter: 'twitter',
    instagram: 'instagram'
  }

  ALTERNATIVE = {
    poll: 'poll',
    sms: 'sms',
    password: 'password',
    simple: 'simple'
  }

  METHODS = NETWORKS.values + ALTERNATIVE.values

  enum state: [ :pending, :approved, :unapproved ]

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

  aasm column: :state, enum: true, whiny_transitions: false do
    state :pending, initial: true
    state :unapproved
    state :approved

    before_all_events :delete_old_notification

    event :approve do
      transitions from: :pending, to: :approved
    end

    event :unapprove, before: :notify_general do
      transitions from: :pending, to: :unapproved
    end

    event :modify, before: :notify_franchisee  do
      transitions from: [:unapproved, :approved], to: :pending, unless: lambda { pending? }
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

  def postable?
    Auth::NETWORKS.keys.reject{ |net| net == :instagram }.include? name
  end

  def name
    resource.class::NAME.to_sym
  end

  def self.network_classes
    Auth::NETWORKS.values.map { |network| network.capitalize + "Profile" }
  end

  private

  def delete_old_notification
    notification.destroy if notification
  end

  def notify_general
    if network?
        create_notification(
          category: :unapproved_authentication,
          user: place.user
        )
    end
  end

  def notify_franchisee
    if network?
        create_notification(
          category: :modified_authentication,
          user: place.user.franchisee
        )
    end
  end

end
