class Profile < ActiveRecord::Base
  belongs_to :customer
  belongs_to :resource, polymorphic: true, dependent: :destroy

  accepts_nested_attributes_for :resource

  validates :customer_id, presence: true

  def resource_attributes=(attributes, options = {})
    if persisted?
      super attributes
    else
      self.resource = resource_type.constantize.new(attributes, options)
    end
  end
end
