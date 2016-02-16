require "rails_helper"

RSpec.describe BannerPolicy do
  include_examples "visitor"

  subject { StylePolicy.new(user,record) }


  let(:attributes){subject.permitted_attributes;}
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
      attributes.each do |attr|
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
      attributes.each do |attr|
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
      attributes.each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

      it{ is_expected.to permit_crud}
  end
end
