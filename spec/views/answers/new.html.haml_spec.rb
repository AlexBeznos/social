require 'rails_helper'

RSpec.describe "answers/new", :type => :view do
  before(:each) do
    assign(:answer, Answer.new(
      :content => "MyString",
      :poll_id => 1
    ))
  end

  it "renders new answer form" do
    render

    assert_select "form[action=?][method=?]", answers_path, "post" do

      assert_select "input#answer_content[name=?]", "answer[content]"

      assert_select "input#answer_poll_id[name=?]", "answer[poll_id]"
    end
  end
end
