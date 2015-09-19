require 'rails_helper'

RSpec.describe "answers/index", :type => :view do
  before(:each) do
    assign(:answers, [
      Answer.create!(
        :content => "Content",
        :poll_id => 1
      ),
      Answer.create!(
        :content => "Content",
        :poll_id => 1
      )
    ])
  end

  it "renders a list of answers" do
    render
    assert_select "tr>td", :text => "Content".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
