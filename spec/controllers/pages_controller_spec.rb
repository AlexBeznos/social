require 'rails_helper'

RSpec.describe PagesController, :type => :controller do
  context 'renders proper home template depends on domain' do

    it 'to home_am' do
      allow_any_instance_of(ActionController::TestRequest).to receive(:host).and_return('gofriends.am')
      get_home

      expect(response).to render_template :home_am
    end

    it 'to home' do
      get_home
    
      expect(response).to render_template :home
    end
  end
end

def get_home
  get :show, id: 'home'
end
