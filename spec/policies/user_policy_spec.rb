require "rails_helper"

RSpec.describe UserPolicy do
  include_examples "visitor"

  subject { UserPolicy.new(user, record) }
  let(:record){ create :user }

  let(:attributes){[
    :email,
    :first_name,
    :last_name,
    :phone,
    :timezone,
    :password,
    :password_confirmation
  ]}

  let(:resolved_scope) {
    UserPolicy::Scope.new(user, User.all).resolve
  }

  context "for admin" do
    let(:user){ create :user_admin }

    it "scope includes user with id: current_user.id" do
      expect(resolved_scope).to include(user)
    end


    it "permit mass assigment of all attributes" do
      attributes.each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

    it{ is_expected.to permit_crud }
  end

  context "for franchisee" do
    let(:record){ create :user_general, franchisee: create(:user_franchisee) }
    let(:user){ record.franchisee }

    it "scope includes user with id: current_user.id" do
      expect(resolved_scope).to include(user)
    end


    it "permit mass assigment of all attributes" do

      attributes.each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

    it{ is_expected.to permit_action(:index)}
    it{ is_expected.to permit_edit_and_update_actions}
    it{ is_expected.to forbid_action(:destroy)}
    it{ is_expected.to permit_new_and_create_actions }
  end

  context "for general" do
    let(:user){ create :user_general }
    let(:record){ user }

    it "scope includes user with id: current_user.id" do
      expect(resolved_scope).to include(user)
    end

    it "permit mass assigment of all attributes" do
      attributes.each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

    it{ is_expected.to forbid_action(:index)}
    it{ is_expected.to permit_edit_and_update_actions}
    it{ is_expected.to forbid_action(:destroy)}
    it{ is_expected.to forbid_new_and_create_actions }

  end
end
