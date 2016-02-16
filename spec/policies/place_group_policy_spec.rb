require "rails_helper"

RSpec.describe PlaceGroupPolicy do
  include_examples "visitor"

  subject { PlaceGroupPolicy.new(user,record) }


  let(:attributes){subject.permitted_attributes;}
  let(:record){ create :place_group, user:(create :user_general) }
  let(:resolved_scope) {
    PlaceGroupPolicy::Scope.new(user, PlaceGroup.all).resolve
  }

  context "for admin" do
    let(:user){create :user_admin}

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

  context "for franchisee" do
    let(:user){create :user_franchisee}

    #FIXME: I don`t understand scope logic 
    # it "scope includes user with id: current_user.id" do
    #   expect(resolved_scope).to include(create :place_group, user: user)
    # end


    it "permit mass assigment of all attributes" do
      attributes.each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

    it{ is_expected.to permit_crud}
  end

  context "for general" do
    let(:user){create :user_general}

    it "scope includes user with id: current_user.id" do
      expect(resolved_scope).to include(create :place_group, user: user)
    end

    it "permit mass assigment of all attributes" do
      attributes.each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

      it{ is_expected.to permit_crud}
  end
end
