require 'rails_helper'

RSpec.describe Customer::Visit do
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:place) }
  it { is_expected.to belong_to(:network_profile).class_name('Customer::NetworkProfile') }
  # it { is_expected.to validate_presence_of :network_profile }
  # it { is_expected.to validate_presence_of :place }
  it { is_expected.to callback(:calculate_reputation).after(:create).unless('by_password || by_sms') }

  describe "Does not validate presence of" do
    context "network profile" do
      it "when user enters by password" do
        # byebug
        visit = build_stubbed(:visit, customer_network_profile_id: nil, by_password: true)
        expect(visit).to be_valid
      end
    end

    context "place" do
      it "when user enters by password" do
        visit = build_stubbed(:visit, place: nil, by_password: true)
        expect(visit).to be_valid
      end
    end
  end

  describe "Validate presence of" do
    context "network profile" do
      # it "when enter by password is false" do # TODO: This test doesn't pass. undefined method `social_network_id' for nil:NilClass ./app/models/customer/visit.rb:23
      #   visit = build(:visit, customer_network_profile_id: nil, by_password: false)
      #   expect(visit).not_to be_valid
      # end
    end

    context "place" do
      it "when enter by password is false" do
        visit = build_stubbed(:visit, place: nil, by_password: false)
        expect(visit).not_to be_valid
      end
    end
  end

  describe "Calculate reputation" do
    let(:visit) { build_stubbed(:visit) }


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
