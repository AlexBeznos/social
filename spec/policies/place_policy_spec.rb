require "rails_helper"

RSpec.describe PlacePolicy do
  include_examples "visitor"

  subject { PlacePolicy.new(user,record) }


  let(:permitted_attributes) do
    [
      :name,
      :logo,
      :enter_by_password,
      :password,
      :active,
      :redirect_url,
      :user_id,
      :stocks_active,
      :polls_active,
      :reputation_on,
      :simple_enter,
      :score_amount,
      :city,
      :display_other_banners,
      :display_my_banners,
      :loyalty_program,
      :domen_url,
      :sms_auth,
      :place_group_id,
      :auth_default_lang,
      :ssid
    ]
  end
  let(:record){ create :place}
  let(:resolved_scope) {
    PlacePolicy::Scope.new(user, Place.all).resolve
  }

  context "for admin" do
    let(:user){create :user_admin}

    it "scope includes user with user: current_user" do
      expect(resolved_scope).to include(record)
    end


    it "permit mass assigment of all attributes" do
      permitted_attributes.each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

    it{ is_expected.to permit_crud}
    it{ is_expected.to permit_place_additional_actions}
  end

  context "for franchisee" do
    let(:user){create :user_franchisee}

    it "scope includes user with user: current_user" do
      expect(resolved_scope).to include(create :place, user: user)
    end


    it "permit mass assigment of all attributes" do
      permitted_attributes.each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

    it{ is_expected.to permit_crud}
    it{ is_expected.to permit_place_additional_actions}
  end

  context "for general" do
    let(:user){create :user_general}

    it "scope includes place with user: current_user" do
      expect(resolved_scope).to include(create :place, user: user)
    end

    it "permit mass assigment of all attributes" do
      permitted_attributes.each do |attr|
        is_expected.to permit_mass_assignment_of(attr)
      end
    end

    it{ is_expected.to permit_action(:index)}
    it{ is_expected.to permit_edit_and_update_actions}
    it{ is_expected.to forbid_action(:destroy)}
    it{ is_expected.to forbid_new_and_create_actions }
    it{ is_expected.to forbid_action(:download_settings)}
    it{ is_expected.to permit_action(:settings)}
    it{ is_expected.to permit_action(:guests)}
    it{ is_expected.to permit_action(:birthdays)}

  end
end
