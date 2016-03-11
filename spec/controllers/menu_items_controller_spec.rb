require 'rails_helper'

RSpec.describe MenuItemsController, type: :controller do
  # FIXME: does not pass
  # it happens because of of pundit authorization
  # figure out how to properly stub policies is controller specs
  # let(:user) { create(:user) }
  # let(:place) { create(:place, user: place) }
  #
  # describe 'GET #index' do
  #   let(:menu_items) { create_list(:menu_item, 2) }
  #
  #   before do
  #     get :index, { place_id: place  }
  #   end
  #
  #   it 'populates an instance with menu_items' do
  #     expect(assigns(:menu_items)).to match_array(menu_items)
  #   end
  #
  #   it 'renders index view' do
  #     expect(response).to render_template :index
  #   end
  # end
end
