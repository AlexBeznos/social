require 'rails_helper'

RSpec.describe "answers/edit", :type => :view do
  before(:each) do
    @answer = assign(:answer, Answer.create!(
      :content => "MyString",
      :poll_id => 1
    ))
  end

  it "renders the edit answer form" do
    render

    assert_select "form[action=?][method=?]", answer_path(@answer), "post" do

      assert_select "input#answer_content[name=?]", "answer[content]"

      assert_select "input#answer_poll_id[name=?]", "answer[poll_id]"
    end
  end
end
