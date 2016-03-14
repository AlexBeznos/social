require "rails_helper"

RSpec.describe BannerPolicy do
  include_examples "visitor"

  subject { BannerPolicy.new(user,record) }

  let(:attributes){subject.permitted_attributes;}
  let(:record){ create :banner}
  let(:place){ create :place, user: user }
  let(:resolved_scope) {
    BannerPolicy::Scope.new(user, Banner).resolve
  }

  context "for admin" do
    let(:user){create :user_admin}

    it "scope includes all banners" do
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
    let(:record){ create :banner, place: place }

    it "scope includes all banners" do
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
    let(:record){ create :banner, place: place }

    it "scope includes all banners" do
      place.reload
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
