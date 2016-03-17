require "rails_helper"

RSpec.describe NotificationPolicy do
  include_examples "visitor"

  subject { NotificationPolicy.new(user,record) }
  let(:record){ create :notification }
  let(:resolved_scope) {
    NotificationPolicy::Scope.new(user, Notification.all).resolve
  }

  context "for admin" do
    let(:user) { create :user_admin }
    let(:record){ create :notification }

    it "scope includes all users" do
      expect(resolved_scope).to include record
    end

    it { is_expected.to permit_action(:destroy) }
  end

  context "for franchisee" do
    let(:user) { create :user_franchisee }
    let(:record){ create :notification, user: user }

    it "scope includes all users" do
      expect(resolved_scope).to include record
    end

    it { is_expected.to permit_action(:destroy) }
  end

end
