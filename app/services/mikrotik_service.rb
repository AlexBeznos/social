class MikrotikService
  def initialize(router, config_name)
    @router = router
    @config_name = config_name
  end

  def load! # NOTE: don't used currenty
    cmnds = normalized_commands

    MTik::command(
      host: @router.ip,
      user: @router.class::API_USERNAME,
      pass: @router.mt_api_password,
      command: cmnds
    ).to_json
  end

  def normalized_commands
    File.readlines(path_to_config).map do |line|
      matched_macros.each do |macro, value|
        line.chomp!
        line.gsub! Regexp.new(macro), value
      end
    end
  end

  private

  def path_to_config
    File.join(Rails.root, 'vendor', 'router', 'configs', "#{@config_name}")
  end

  def matched_macros
    {
      '##SSID##' => @router.place.ssid,
      '##HP_USERNAME##' => @router.hp_username,
      '##HP_PASSWORD##' => @router.hp_password,
      '##MT_ADMIN_PASSWORD##' => @router.mt_password,
      '##MT_API_PASSWORD##' => @router.mt_api_password,
      '##MT_API_USERNAME##' => @router.class::API_USERNAME
    }
  end
end
