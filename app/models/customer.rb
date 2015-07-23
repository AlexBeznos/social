class Customer < ActiveRecord::Base

  has_many :network_profiles, :dependent => :destroy, :class_name => 'Customer::NetworkProfile'
  has_many :visits, :dependent => :destroy, :class_name => 'Customer::Visit'
  has_many :reputations, :dependent => :destroy, :class_name => 'Customer::Reputation'
  has_and_belongs_to_many :menu_items

  accepts_nested_attributes_for :network_profiles

  validates :first_name, presence: true
  
  before_save :get_more_customer_info, if: 'first_name =~ /unfinished/'
  before_save :set_gender, unless: 'gender'


  def full_name
    if first_name && last_name
      "#{first_name} #{last_name}"
    else
      first_name
    end
  end

  private
    def get_more_customer_info
      begin
        params = Object.const_get("#{first_name.split('#')[1].capitalize}Service").get_more_customer_info(self)
        self.assign_attributes(params)
      rescue
      end
    end

    def set_gender
      gender = Guess.gender(self.full_name)[:gender]
      self.gender = gender unless gender == 'unknown'
    end
end
