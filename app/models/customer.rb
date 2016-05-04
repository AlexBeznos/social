class Customer < ActiveRecord::Base

  has_many :network_profiles, dependent: :destroy, class_name: 'Customer::NetworkProfile'
  has_many :visits, dependent: :destroy, class_name: 'Customer::Visit'
  has_many :reputations, dependent: :destroy, class_name: 'Customer::Reputation'
  has_many :orders, dependent: :destroy
  has_many :profiles, dependent: :destroy
  has_many :ahoy_visits
  belongs_to :social_network

  accepts_nested_attributes_for :network_profiles

  scope :by_birthday, -> (from, till) { joins(:visits)
                                          .where("(extract(month from birthday) = ? and extract(day from birthday) >= ?) or
                                        (extract(month from birthday) = ? and extract(day from birthday) <= ?)",
                                                 from.strftime("%m"), from.strftime("%d"),
                                                 till.strftime("%m"), till.strftime("%d"))
                                          .sort { |a, b| sort_by_birthday a, b } }

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

  def set_gender # FIXME: Set this shit to be found in Profle resource generation
    gender = Guess.gender(self.full_name)[:gender]
    self.gender = gender unless gender == 'unknown'
  end
end
