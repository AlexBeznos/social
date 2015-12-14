require 'rails_helper'

RSpec.describe GowifiSmsRemoveWorker do
  it { is_expected.to be_processed_in :sms_remove }
  it { is_expected.to be_retryable false }
end
