require 'rails_helper'

RSpec.describe Message do
  # it { is_expected.to have_attached_file(:image) }
  it { is_expected.to belong_to(:with_message) }
  it { is_expected.to belong_to(:social_network) }
  it { is_expected.to validate_presence_of :social_network_id }
  # it { is_expected.to validate_attachment_content_type(:image).allowing("image/jpeg", "image/png", "image/gif") }
  it { is_expected.to callback(:set_subscription_uid).before(:save).if('social_network_id == 3') }
  it { is_expected.to callback(:set_active_only_to_one_message_from_place).after(:save).if('active') }
  #it { is_expected.to validate_presence_of :redirect_url}  NOTE: IT`S FROM OTHER TASK FROM BRANCH "redirect" AND IT`S APPEARED HERE SOMEHOW

  it "should only return active messages" do
    Message.active.where_values_hash.should eq "active" => true
  end

  describe "Validate presence of message" do
    it "required when social network is not Instagram" do
      message = build_stubbed(:message, social_network_id: 2)
      expect(message).to be_valid
    end

    it "not required when social network is Instagram" do
      message = build_stubbed(:message, message: nil, social_network_id: 3, subscription: "Subscription")
      expect(message).to be_valid
    end
  end

  describe "Validate message link" do
    it "has valid value" do
      message = build_stubbed(:message, message_link: "http://google.com")

      expect(message).to be_valid
    end

    it "has invalid value" do
      message = build_stubbed(:message, message_link: "google.com")
      message.valid?
      expect(message.errors.messages[:message_link]).to include(I18n.t('models.errors.validations.wrong_link_format'))
    end
  end

  describe "Validate presence of subscription" do
    it "required when social network is Instagram" do
      message = build_stubbed(:message, social_network_id: 3, subscription: "Subscription")
      expect(message).to be_valid
    end

    it "not required when social network is not Instagram" do
      message = build_stubbed(:message, social_network_id: 2, subscription: "Subscription")
      expect(message).to be_valid
    end
  end

  describe "Validate Twitter message length" do
    it "have to be less than 141 symbol" do
      message = build_stubbed(:message, social_network_id: 4, message: "a" * 141, message_link: "http://google.com")
      message.valid?
      expect(message.errors.messages[:message]).to include(I18n.t('models.errors.validations.long_twitter_message'))
    end
  end
end
