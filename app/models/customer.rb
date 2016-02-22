class Customer < ActiveRecord::Base

  has_many :network_profiles, :dependent => :destroy, :class_name => 'Customer::NetworkProfile'
  has_many :visits, :dependent => :destroy, :class_name => 'Customer::Visit'
  has_many :reputations, :dependent => :destroy, :class_name => 'Customer::Reputation'
  has_many :orders, :dependent => :destroy
  belongs_to :social_network

  accepts_nested_attributes_for :network_profiles

  validates :first_name, presence: true

  before_save :get_more_customer_info, if: 'first_name =~ /unfinished/'
  before_save :set_gender, unless: 'gender'
  scope :by_birthday, -> (from, till) { joins(:visits)
                                .where("(extract(month from birthday) = ? and extract(day from birthday) >= ?) or
                                        (extract(month from birthday) = ? and extract(day from birthday) <= ?)",
                                        from.strftime("%m"), from.strftime("%d"),
                                        till.strftime("%m"), till.strftime("%d"))
                                .sort { |a, b| sort_by_birthday a, b } }


  def full_name
    if first_name && last_name
      "#{first_name} #{last_name}"
    else
      first_name
    end
  end

  private
    def self.sort_by_birthday a, b
      case
        when a.birthday.strftime('%m%d').to_i < b.birthday.strftime('%m%d').to_i
          if a.birthday.strftime('%m').to_i == 1 and b.birthday.strftime('%m').to_i == 12
            1
          else
            -1
          end
        when a.birthday.strftime('%m%d').to_i > b.birthday.strftime('%m%d').to_i
          if a.birthday.strftime('%m').to_i == 12 and b.birthday.strftime('%m').to_i == 1
            -1
          else
            1
          end
        else
          0
        end
    end

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
