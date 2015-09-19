require 'rails_helper'

RSpec.describe "polls/index", :type => :view do
  before(:each) do
    assign(:polls, [
      Poll.create!(
        :question => "MyText",
        :place_id => 1
      ),
      Poll.create!(
        :question => "MyText",
        :place_id => 1
      )
    ])
  end

  it "renders a list of polls" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
