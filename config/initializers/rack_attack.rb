class Rack::Attack
  Rack::Attack.blacklist('block requests from fitcurves path') do |req|
    req.path.include? 'wifi/fitcurves/login'
  end
end
