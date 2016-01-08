RSpec.shared_examples 'validates redirect_url' do
  it { is_expected.to validate_presence_of :redirect_url }
end

RSpec.shared_examples 'standart network setup' do
  it { is_expected.to validate_presence_of :message }
  it { is_expected.to validate_presence_of :message_url }
  it { is_expected.to validate_presence_of :image }
end
