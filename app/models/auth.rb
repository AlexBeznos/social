class Auth < ActiveRecord::Base
  NETWORKS = %w(
    vk
    facebook
    twitter
  )

  METHODS = NETWORKS + %w(
    poll
    sms
    password
  )

  default_scope { where(active: true) }

  belongs_to :place
  belongs_to :resource, polymorphic: true, autosave: true

  validates :redirect_url, presence: true, url: true
  validates :resource_type, uniqueness: { scope: [:place_id, :active] }

  accepts_nested_attributes_for :resource

  def resource_attributes=(attributes, options = {})
    self.resource = resource_type.constantize.new(attributes, options)
  end
end
