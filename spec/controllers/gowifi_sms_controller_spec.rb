require 'rails_helper'

RSpec.describe GowifiSmsController, :type => :controller do
  let(:place) { create :place }

  it do
    should route(:post, "/wifi/#{place.slug}/gowifi_sms").to(
      action: :create,
      controller: :gowifi_sms,
      slug: place.slug
    )
  end

  it do
    sms = create :gowifi_sms, place: place
    should route(:post, "/wifi/#{place.slug}/gowifi_sms/#{sms.id}/resend").to(
      action: :resend,
      controller: :gowifi_sms,
      slug: place.slug,
      id: sms.id
    )
  end

  context '#create' do
    before do
      post :create, slug: place.slug, gowifi_sms: { phone: phone }
    end

    context 'with success' do
      let(:phone) { Faker::PhoneNumber.phone_number }

      it 'should add gowifi_sms record' do
        expect(GowifiSms.all.length).to eq 1
      end

      it 'should redirect to confirmaytion path' do
        expect(response).to redirect_to(gowifi_sms_confirmation_path(place.slug, GowifiSms.last ))
      end

      include_examples "with_status", :ok
    end

    context 'with failure' do
      let(:phone) { 'not_a_phone' }

      it 'should not create gowifi_sms record' do
        expect(GowifiSms.all.length).to eq 0
      end

      include_examples "with_status", :not_acceptable

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
      let(:gowifi_sms) { create(:gowifi_sms, place: place) }
      let(:id) { gowifi_sms.id }

      before do
        Timecop.travel( gowifi_sms.updated_at + 26.seconds )
        post :resend, id: id, slug: place.slug
      end

      it 'should add job to queue' do
        expect(GowifiSmsSendWorker.jobs.size).to eq 2 # 1 after save + 1 after resend
      end

      include_examples "with_status", :ok
      include_examples "with_blank_response"
    end

    context 'with failure' do
      let(:id) { Faker::Number.number(Faker::Number.number(1).to_i) }

      before do
        post :resend, id: id, slug: place.slug
      end

      it 'should not add job to queue' do
        expect(GowifiSmsSendWorker.jobs.size).to eq 0
      end

      include_examples "with_status", :not_acceptable

      it 'should have error in body' do
        expect(response.body).to include('error')
      end
    end
  end
end
