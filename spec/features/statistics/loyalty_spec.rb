require 'rails_helper'

describe "loyalty statistic" do
    let(:user){ create :user }
    let(:place){ create :place, user: user }
    let(:today_order){ create :order, place: place }
    let(:last_week_order){  create :last_week_order, place: place }
    let(:last_month_order){  create :last_month_order, place: place }


    before(:each)do
      login(user)
    end

    it "shows orders today" do
      today_order.customer.reputations << create(:reputation, place: place)

      visit place_statistics_loyalty_path(place)
      click_link("Today")

      expect(page).to have_selector("#order_#{today_order.id}")
    end

    it "shows orders of this week" do
      last_week_order.customer.reputations << create(:reputation, place: place)

      visit place_statistics_loyalty_path(place)
      click_link("This week")

      expect(page).to have_selector("#order_#{last_week_order.id}")
    end

    it "shows orders of this month" do
      last_month_order.customer.reputations << create(:reputation, place: place)

      visit place_statistics_loyalty_path(place)
      click_link("This month")

      expect(page).to have_selector("#order_#{last_month_order.id}")

    end

    describe "date piker", js: true do
      it "shows orders of custom date" do
        last_month_order.customer.reputations << create(:reputation, place: place)
        today = Time.now.day
        month_ago = (Time.now - 1.month).day

        visit place_statistics_loyalty_path(place)
        click_button("Custom date")

        find("#from").click
        find("a[title='Prev']").click
        find("a[class='ui-state-default']", text: month_ago, visible: true).click

        find("#to").click
        find("a.ui-state-default", text: today, visible: true).click
        find("input[value='Submit']").click

        expect(page).to have_selector("#order_#{last_month_order.id}")
      end
    end

end
