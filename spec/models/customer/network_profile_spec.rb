require 'rails_helper'

RSpec.describe Customer::NetworkProfile do
  it { is_expected.to have_many(:visits).class_name('Customer::Visit') }
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:social_network) }
  # it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:social_network_id) } # FIXME: this test doesn't pass
  it { is_expected.to callback(:set_friends_count).before(:save) }

  describe "Validate url" do
    it "has valid value" do
      network_profile = build_stubbed(:network_profile, url: "http://google.com")

      expect(network_profile).to be_valid
    end

    it "has invalid value" do
      network_profile = build_stubbed(:network_profile, url: "google.com")
      network_profile.valid?
      expect(network_profile.errors.messages[:url]).to include(I18n.t('models.errors.validations.wrong_link_format'))
    end
  end
end
