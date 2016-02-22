require "rails_helper"

RSpec.describe BannerPolicy do
  include_examples "visitor"

  subject { BannerPolicy.new(user,record) }

  let(:permitted_attributes){
    [
      :name,
      :content
    ]
  }


  let(:record){ create :banner}
  let(:resolved_scope) {
    BannerPolicy::Scope.new(user, Banner.all).resolve
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

    it "scope includes all banners" do
      expect(resolved_scope).to include(record)
    end


    it "permit mass assigment of attributes" do
      permitted_attributes.each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

    it{ is_expected.to permit_crud}
  end

  context "for general" do
    let(:user){create :user_general}

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
end
