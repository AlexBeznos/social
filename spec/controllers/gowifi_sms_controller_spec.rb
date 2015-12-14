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
    id = Faker::Number.number(Faker::Number.number(1).to_i)
    should route(:post, "/wifi/#{place.slug}/gowifi_sms/#{id}/resend").to(
      action: :resend,
      controller: :gowifi_sms,
      slug: place.slug,
      id: id
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

      include_examples "with_status", :ok
      include_examples "with_blank_response"
    end

    context 'with failure' do
      let(:phone) { 'not_a_phone' }

      it 'should not create gowifi_sms record' do
        expect(GowifiSms.all.length).to eq 0
      end

      include_examples "with_status", :not_acceptable

      it 'should have error in body' do
        expect(response.body).to include('error')
      end
    end

  end

  context '#resend' do
    before do
      post :resend, id: id, slug: place.slug
    end

    context 'with success' do
      let(:gowifi_sms) { create(:gowifi_sms, place: place) }
      let(:id) { gowifi_sms.id }

      it 'should add job to queue' do
        expect(GowifiSmsWorker.jobs.size).to eq 2 # 1 after save + 1 after resend
      end

      include_examples "with_status", :ok
      include_examples "with_blank_response"
    end

    context 'with failure' do
      let(:id) { Faker::Number.number(Faker::Number.number(1).to_i) }

      it 'should not add job to queue' do
        expect(GowifiSmsWorker.jobs.size).to eq 0
      end

      include_examples "with_status", :not_acceptable

      it 'should have error in body' do
        expect(response.body).to include('error')
      end
    end
  end
end
