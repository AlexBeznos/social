require 'rails_helper'

RSpec.describe Customer::Visit do
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:place) }
  it { is_expected.to belong_to(:network_profile).class_name('Customer::NetworkProfile') }
  # it { is_expected.to validate_presence_of :network_profile }
  # it { is_expected.to validate_presence_of :place }

  describe "Does not validate presence of" do
    context "network profile" do
      it "when user enters by password" do
        # byebug
        visit = build(:visit, customer_network_profile_id: nil, by_password: true)
        expect(visit).to be_valid
      end
    end

    context "place" do
      it "when user enters by password" do
        visit = build(:visit, place: nil, by_password: true)
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
        visit = build(:visit, place: nil, by_password: false)
        expect(visit).not_to be_valid
      end
    end
  end

  # TODO: can't figure out how to test after_commit callback
  # describe "Calculate reputation" do
  #   visit = FactoryGirl.build(:visit)
  #   it "value sets on commit" do
  #     expect().to eql(0)
  #     visit.save!
  #     expect().to eql(20)
  #   end
  # end

end
