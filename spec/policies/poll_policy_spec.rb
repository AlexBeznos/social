require "rails_helper"

RSpec.describe PollPolicy do
  include_examples "visitor"

  subject { PollPolicy.new(user,record) }

  let(:permitted_attributes) do
    [
      :question,
      answers_attributes: [
        :id,
        :content,
        :_destroy
      ]
    ]
  end
  let(:record){ create :poll}
  let(:resolved_scope) {
    PollPolicy::Scope.new(user, Poll.all).resolve
  }

  context "for admin" do
    let(:user){create :user_admin}

    it "scope includes all banners" do
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

    it "scope includes all polls" do
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

    it "scope includes all polls" do
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
