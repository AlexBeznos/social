Dumper::Agent.start_if(app_key: ENV['DUMPER_KEY']) do
  Rails.env.production? && ENV.fetch('DUMPER_KEY', false)
end
