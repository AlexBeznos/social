require 'rails_helper'

RSpec.describe Customer::Visit do
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:place) }
  it { is_expected.to belong_to(:account) }
  it { is_expected.to callback(:calculate_reputation).after(:create).unless(:by_password? || :by_sms?) }

  describe "Calculate reputation" do
    let(:instagram) { create(:instagram_profile) }
    let(:visit) { build_stubbed(:visit, account_type: instagram.profile.resource_type, account_id: instagram.profile.resource_id) }

    it "create reputation if does not exist" do
      expect{ Customer::Reputation.calculate(visit) }.to change{Customer::Reputation.count}.by(1)
    end

    #FIXME: doesn't update reputation
    # it "when reputation exists" do
    #   reputation = Customer::Reputation.find_by(place_id: visit.place_id, customer_id: visit.customer_id)
    #   expect{ Customer::Reputation.calculate(visit) }.to change{reputation.score}.by(20)
    # end
  end

end
