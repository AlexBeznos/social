class Customer::Reputation < ActiveRecord::Base
  belongs_to :customer
  belongs_to :place

  validates :place, :customer, :score, presence: true
  validates :place_id, uniqueness: {
    scope: :customer_id,
    on: :create
  }

  def self.calculate(visit)
    reputation = Customer::Reputation.find_by(place: visit.place, customer: visit.customer)

    if reputation.nil?
      Customer::Reputation.create!(
        score: visit.place.score_amount,
        place: visit.place,
        customer: visit.customer
      )
    else
      reputation.update!(score: reputation.score + visit.place.score_amount)
    end
  end
end
