require 'rails_helper'

RSpec.describe GowifiSmsSendWorker do
  it { is_expected.to be_processed_in :sms_send }
  it { is_expected.to be_retryable false }
end
