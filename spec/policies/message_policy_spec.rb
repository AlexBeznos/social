require "rails_helper"

RSpec.describe MessagePolicy do
  include_examples "visitor"

  subject { MessagePolicy.new(user,record) }


  let(:permitted_attributes){
    [
      :social_network_id,
      :message,
      :message_link,
      :image,
      :subscription
    ]
  }
  let(:place){ create :place }
  let(:record){ create :message, with_message: place}
  let(:resolved_scope) {
    MessagePolicy::Scope.new(user, Message.all).resolve
  }

  context "for admin" do
    let(:user){create :user_admin}

    it "scope includes user messages" do
      expect(resolved_scope).to include(record)
    end


    it "permit mass assigment of all attributes" do
      permitted_attributes.each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

    it{ is_expected.to permit_crud}
  end

  context "for franchisee" do
    let(:user){create :user_franchisee}

    it "scope includes all messages" do
      expect(resolved_scope).to include(record)
    end


    it "permit mass assigment of all attributes" do
      permitted_attributes.each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

    it{ is_expected.to permit_crud}
  end

  context "for general" do
    let(:user){create :user_general}

    it "scope includes all messages" do
      expect(resolved_scope).to include(record)
    end

    it "permit mass assigment of all attributes" do
      permitted_attributes.each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

      it{ is_expected.to permit_crud}
  end
end
