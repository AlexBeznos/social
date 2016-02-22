require "rails_helper"

RSpec.describe StylePolicy do
  include_examples "visitor"

  subject { StylePolicy.new(user,record) }


  let(:permitted_attributes) do
    [
      :background,
      :text_color,
      :greating_color,
      :css,
      :network_icons
    ]
  end
  let(:record){ create :style}
  let(:resolved_scope) {
    StylePolicy::Scope.new(user, Style.all).resolve
  }

  context "for admin" do
    let(:user){create :user_admin}

    it "scope includes all styles" do
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

    it "scope includes user with id: current_user.id" do
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

    it "scope includes all styles" do
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
