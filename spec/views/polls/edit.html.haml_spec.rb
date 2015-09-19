require 'rails_helper'

RSpec.describe "polls/edit", :type => :view do
  before(:each) do
    @poll = assign(:poll, Poll.create!(
      :question => "MyText",
      :place_id => 1
    ))
  end

  it "renders the edit poll form" do
    render

    assert_select "form[action=?][method=?]", poll_path(@poll), "post" do

      assert_select "textarea#poll_question[name=?]", "poll[question]"

      assert_select "input#poll_place_id[name=?]", "poll[place_id]"
    end
  end
end
