RSpec.shared_examples "with_status" do |status|
  it "should response with #{status} status" do
    expect(response).to have_http_status(status)
  end
end

RSpec.shared_examples "with_blank_response" do
  it 'should have blank body' do
    expect(response.body).to be_blank
  end
end
