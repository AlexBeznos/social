require "rails_helper"


describe "places#index sorting" do
  let(:user){ create :user_franchisee}
  let(:places){
    [
      create(:place),
      create(:last_week_place),
      create(:last_month_place)
    ]
  }

  before(:each) do
    I18n.locale = :en
    user.places << places
    login(user)
    visit places_path
  end

  describe "sort_by dropdown", js: true do
    it "shows places sorted by date of creation" do
      click_button(I18n.t("models.places.actions.index.sort_by"))
      click_link(I18n.t("models.places.actions.index.date_of_creation"))

      link_names = all("a.place-link").map(&:text)
      sorted_places_names = places.map(&:name)

      expect(link_names).to eq(sorted_places_names)
    end

    it "show places sorted in alphabetical order" do
      click_button(I18n.t("models.places.actions.index.sort_by"))
      click_link(I18n.t("models.places.actions.index.alphabet"))

      sorted_places_names = places.map(&:name).sort
      link_names = all("a.place-link").map(&:text)

      expect(link_names).to eq(sorted_places_names)
    end
  end

  describe "search field", js: true do
    it "show place searched" do
      place_name = places.second.name

      fill_in "searchinput", with: place_name
      link_name = find("a.place-link").text

      expect(link_name).to eq(place_name)
    end
  end
end
