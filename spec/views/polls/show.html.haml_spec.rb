require 'rails_helper'

RSpec.describe "polls/show", :type => :view do
  before(:each) do
    @poll = assign(:poll, Poll.create!(
      :question => "MyText",
      :place_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
  end
end
