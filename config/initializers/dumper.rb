Dumper::Agent.start_if(app_key: ENV['DUMPER']) do
  Rails.env.production? && ENV.fetch('DUMPER', false)
end
