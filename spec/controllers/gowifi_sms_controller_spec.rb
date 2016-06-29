require 'rails_helper'

RSpec.describe GowifiSmsController, :type => :controller do
  let(:place) { create :place }

  it do
    expect({ post: "/wifi/#{place.slug}/gowifi_sms" }).to route_to(
      action: 'create',
      controller: 'gowifi_sms',
      slug: place.slug
    )
  end

  it do
    sms = create :gowifi_sms
    expect({ post: "/wifi/#{place.slug}/gowifi_sms/#{sms.id}/resend" }).to route_to(
      action: 'resend',
      controller: 'gowifi_sms',
      slug: place.slug,
      id: sms.id.to_s
    )
  end

  context '#create' do
    before do
      post :create, slug: place.slug, sms_profile: { provider: "sms", phone: phone }
    end

    context 'with success' do
      let(:phone) { Faker::PhoneNumber.phone_number }

      it 'should add gowifi_sms record' do
        expect(SmsProfile.all.length).to eq 1
      end

      it 'should redirect to confirmation path' do
        expect(response).to redirect_to(gowifi_sms_confirmation_path(place.slug, SmsProfile.last ))
      end

      include_examples "with_status", 302
    end

    context 'with failure' do
      let(:phone) { 'not_a_phone' }

      it 'should not create gowifi_sms record' do
        expect(SmsProfile.all.length).to eq 0
      end

      include_examples "with_status", 302

      it 'should redirect to gowifi place' do
        expect(response).to redirect_to(gowifi_place_path(place))
      end

      it 'should have proper alert message' do
        expect(flash[:alert]).to be_present
      end
    end

  end

  context '#resend' do
    context 'with success' do
      let(:gowifi_sms) { create(:gowifi_sms) }
      let(:id) { gowifi_sms.id }

      before do
        post :resend, id: id, slug: place.slug
      end

      include_examples "with_status", :ok
      include_examples "with_blank_response"
    end

    # NOTE: Behavior is broken because of rescue in application_controller.rb
    # context 'with failure' do
    #   let(:id) { Faker::Number.number(Faker::Number.number(1).to_i) }
    #
    #   before do
    #     post :resend, id: id, slug: place.slug
    #   end
    #
    #   include_examples "with_status", :not_acceptable
    #
    #   it 'should have error in body' do
    #     expect(response.body).to include('error')
    #   end
    # end
  end
end
