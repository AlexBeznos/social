require 'rails_helper'

RSpec.describe "polls/new", :type => :view do
  before(:each) do
    assign(:poll, Poll.new(
      :question => "MyText",
      :place_id => 1
    ))
  end

  it "renders new poll form" do
    render

    assert_select "form[action=?][method=?]", polls_path, "post" do

      assert_select "textarea#poll_question[name=?]", "poll[question]"

      assert_select "input#poll_place_id[name=?]", "poll[place_id]"
    end
  end
end
