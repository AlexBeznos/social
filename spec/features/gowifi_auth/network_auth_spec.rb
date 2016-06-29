require "rails_helper"

describe "User clicks on network link" do
  ['vkontakte', 'twitter', 'facebook'].each do |network|
    context "#{network}" do
      let(:place){ create :place }
      let(:network_auth){ create("#{network}_auth".to_sym, posting_enabled: true) }
      let(:auth){ create :auth, resource: network_auth }

      before(:each) do
        if network == 'facebook'
          allow(FacebookService).to receive(:publishing_permitted?) { true }
        end

        place.auths << auth
        auth.approve!
        set_omniauth(network)
        visit gowifi_place_path(slug: place.slug)
        find("a.wifi_link").click
      end

      it "should create advertising worker" do
        expect(AdvertisingWorker.jobs.size).to eq(1)
      end

      it "should create visit" do
        expect(Customer::Visit.count).to eq 1
        expect(Customer::Visit.last.account_type).to eq "#{network.capitalize}Profile"
      end

      it 'should redirect to auth url' do
        expect(current_url).to eq auth.redirect_url
      end
    end
  end

  context "instagram" do
    let(:place){ create :place }
    let(:instagram){ create(:instagram_auth) }
    let(:auth){ create :auth, resource: instagram }

    before(:each) do
      place.auths << auth
      auth.approve!
      set_omniauth('instagram')
      visit gowifi_place_path(slug: place.slug)
      find("a.wifi_link").click
    end

    it "should not create advertising worker" do
      skip("currently do not works in travis ci") do
        expect(AdvertisingWorker.jobs.size).to be_zero
      end
    end

    it "should create visit" do
      expect(Customer::Visit.count).to eq 1
      expect(Customer::Visit.last.account_type).to eq "InstagramProfile"
    end

    it 'should redirect to auth url' do
      expect(current_url).to eq auth.redirect_url
    end
  end
end
