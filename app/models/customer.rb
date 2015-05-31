class Customer < ActiveRecord::Base
  has_many :network_profiles, :dependent => :destroy, :class_name => 'Customer::NetworkProfile'
  accepts_nested_attributes_for :network_profiles

  validates :first_name, presence: true


  def full_name
    if first_name && last_name
      "#{first_name} #{last_name}"
    else
      first_name
    end
  end
end
