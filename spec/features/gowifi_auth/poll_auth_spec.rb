require "rails_helper"

describe "User submit poll authentication", js: true do
  let(:place){ create :place }
  let(:poll_auth){ create :poll_auth }
  let(:auth){ create :auth, resource: poll_auth }
  let(:gowifi_path) { gowifi_place_path(slug: place.slug) }

  before(:each) do
    place.auths << auth
  end

  context "when submit not filled poll" do
    before do
      I18n.locale = place.auth_default_lang
      visit gowifi_path
    end

    it "should redirect back" do
      find("#poll-button").click
      find("form .poll-btn").click

      expect(current_path).to eq(gowifi_path)
      expect(page).to have_content(I18n.t('wifi.poll_error'))
    end
  end

  context "when submit poll" do
    before do
      3.times do
        poll_auth.answers << create(:answer, content: Faker::Hacker.noun)
      end

      visit gowifi_path
    end

    it "should redirect to auth redirect url and increase number_of_selections" do
      answer_id = poll_auth.answers.sample.id

      click_button("poll-button")
      find("form .radio_buttons #poll_auth_answer_ids_#{answer_id}").click
      find("form .poll-btn").click

      expect(current_url).to eq(auth.redirect_url)
      expect(Answer.find(answer_id).number_of_selections).to eq 1
    end
  end
end
