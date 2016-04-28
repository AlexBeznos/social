require 'rails_helper'

describe "Accessing pages" do
  context "when user is admin" do
    let!(:admin) { create :user_admin }
    let(:place) { create :place, user: admin }
    let(:asd) { root_path }

    before do
      login(admin)
    end

    it "has global visits statistics item in menu" do
      expect(page).to have_content "Глобальная статистика"
    end

    it "has access to global visits statistics page" do
      visit global_statistics_visits_path
      expect(current_path).to eq global_statistics_visits_path
      expect(page).to have_content "Браузер"
    end

    it "has visits statistics item in menu on the place page" do
      visit place_path(place)
      expect(page).to have_content "Статистика посещений"
    end

    it "has access to visits statistics of a place" do
      visit place_statistics_visits_path(place)
      expect(current_path).to eq place_statistics_visits_path(place)
      expect(page).to have_content "Браузер"
    end
  end

  context "when user is not admin" do
    let(:user) { create :user }
    let(:place) { create :place, user: user }

    before do
      login(user)
    end

    it "doesn't have global visits statistics item in menu" do
      expect(page).not_to have_content "Глобальная статистика"
    end

    it "doesn't have access to global visits statistics page" do
      visit global_statistics_visits_path
      expect(page).not_to eq global_statistics_visits_path
      expect(page).to have_content "У вас нет доступа к этой странице"
    end

    it "doesn't have visits statistics item in menu on the place page" do
      visit place_path(place)
      expect(page).not_to have_content "Статистика посещений"
    end

    it "doesn't have access to visits statistics of a place" do
      visit place_statistics_visits_path(place)
      expect(page).not_to eq place_statistics_visits_path(place)
      expect(page).to have_content "У вас нет доступа к этой странице"
    end
  end
end
