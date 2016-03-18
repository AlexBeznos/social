require "rails_helper"

RSpec.describe StockPolicy do
  include_examples "visitor"

  subject { StockPolicy.new(user,record) }


  let(:attributes){[:image, :day]}
  let(:record){ create :stock }
  let(:place){ create :place, user: user }
  let(:resolved_scope) {
    StockPolicy::Scope.new(user, Stock.all).resolve
  }

  context "for admin" do
    let(:user){ create :user_admin }

    it "scope includes all stocks" do
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
    let(:user){ create :user_franchisee }
    let(:record){ create :stock, place: place }

    it "scope includes all stocks" do
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
    let(:record){ create :stock, place: place }

    it "scope includes all stocks" do
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
