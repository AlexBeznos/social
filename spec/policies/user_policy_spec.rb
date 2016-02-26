require "rails_helper"

RSpec.describe UserPolicy do
  include_examples "visitor"

  subject { UserPolicy.new(user,record) }

  let(:permitted_attributes) do
    [
      :email,
      :first_name,
      :last_name,
      :phone,
      :timezone,
      :password,
      :password_confirmation
    ]
  end
  let(:record){ create :user}
  let(:resolved_scope) {
    UserPolicy::Scope.new(user, User.all).resolve
  }

  context "for admin" do
    let(:user){create :user_admin}

    it "scope includes user with id: current_user.id" do
      expect(resolved_scope).to include(user)
    end

    it "permit mass assigment of all attributes" do
      (permitted_attributes + [:group]).each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

    it{ is_expected.to permit_crud}
  end

  context "for franchisee" do
    let(:user){create :user_franchisee}

    it "scope includes user with id: current_user.id" do
      expect(resolved_scope).to include(user)
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

    it "scope includes user with id: current_user.id" do
      expect(resolved_scope).to include(user)
    end

    it "permit mass assigment of all attributes" do
      permitted_attributes.each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

    it{ is_expected.to forbid_action(:index)}
    it{ is_expected.to permit_edit_and_update_actions}
    it{ is_expected.to forbid_action(:destroy)}
    it{ is_expected.to forbid_new_and_create_actions }

  end
end
