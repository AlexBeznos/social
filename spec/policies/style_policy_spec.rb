require "rails_helper"

RSpec.describe StylePolicy do
  include_examples "visitor"

  subject { StylePolicy.new(user,record) }


  let(:attributes){[
      :background,
      :text_color,
      :greating_color,
      :css,
      :network_icons
  ]}
  let(:record){ create :style}
  let(:place){ create :place, user: user }
  let(:resolved_scope) {
    StylePolicy::Scope.new(user, Style).resolve
  }

  context "for admin" do
    let(:user){create :user_admin}

    it "scope includes all styles" do
      expect(resolved_scope).to include(record)
    end


    it "permit mass assigment of all attributes" do
      attributes.each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

    it{ is_expected.to permit_crud}
  end

  context "for franchisee" do
    let(:user){create :user_franchisee}
    let(:record){ create :style, place: place }

    it "scope includes user with id: current_user.id" do
      expect(resolved_scope).to include(record)
    end


    it "permit mass assigment of all attributes" do
      attributes.each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

    it { should permit_action(:index, :new, :create, :show, :edit, :update) }
    it{ should forbid_action(:destroy) }
  end

  context "for general" do
    let(:user){create :user_general}
    let(:record){ create :style, place: place }

    it "scope includes all styles" do
      place.reload
      expect(resolved_scope).to include(record)
    end

    it "permit mass assigment of all attributes" do
      attributes.each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

      it { should permit_action(:index, :new, :create, :show, :edit, :update) }
      it{ should forbid_action(:destroy) }
  end
end
