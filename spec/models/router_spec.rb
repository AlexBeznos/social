require 'rails_helper'

RSpec.describe Router, :type => :model do
  subject { build(:router) }

  it { is_expected.to validate_presence_of :place }

  it { is_expected.to belong_to(:place) }

  it { is_expected.to callback(:set_random_values).before(:create) }
  it { is_expected.to callback(:set_ip).before(:create) }
  it { is_expected.to callback(:initial_setup).after(:commit).on(:create) }
end
