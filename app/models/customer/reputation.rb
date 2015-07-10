class Customer::Reputation < ActiveRecord::Base
  belongs_to :customer
  belongs_to :place

  validates :place_id, uniqueness: { scope: :customer_id,
                                     messages: I18n.t('models.errors.validations.unique_place_for_customer'),
                                     on: :create}

  def self.calculate(object)
    reputation = Customer::Reputation.find_by(place_id: object.place_id)

    if reputation.nil?
      Customer::Reputation.create(place_id: object.place_id, score: object.place.score_amount, customer_id: object.customer_id)
    else
      reputation.update_attributes(score: reputation.score + object.place.score_amount)
    end
  end
end
