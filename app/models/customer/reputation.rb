class Customer::Reputation < ActiveRecord::Base
  belongs_to :customer
  belongs_to :place

  validates :place_id, uniqueness: { scope: :customer_id,
                                     message: I18n.t('errors.unique_place_for_customer'),
                                     on: :create}

  def self.calculate(object)
    reputation = object.customer.reputations.find_by(place_id: object.place_id)

    if reputation.nil?
      object.customer.reputations.create(place_id: object.place_id, score: object.place.score_amount)
    else
      reputation.update_attributes(score: reputation.score + object.place.score_amount)
    end
  end
end
