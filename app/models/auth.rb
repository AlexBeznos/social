class Auth < ActiveRecord::Base
  NETWORKS = {
    vk: 'vk',
    facebook: 'facebook',
    twitter: 'twitter'
  }

  ALTERNATIVE = {
    poll: 'poll'
  }

  METHODS = NETWORKS.values + ALTERNATIVE.values

  default_scope { where(active: true) }

  belongs_to :place
  belongs_to :resource, polymorphic: true, autosave: true

  validates :redirect_url, presence: true, url: true
  validates :resource_type, uniqueness: { conditions: -> { where(active: true) }, scope: :place_id }

  accepts_nested_attributes_for :resource

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
end
