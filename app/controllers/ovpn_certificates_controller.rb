class OvpnCertificatesController < ApplicationController
  skip_after_action :verify_authorized

  def index
    @router = Router.find_by_access_token(params[:access_token])

    if Router::ALLOWED_CRTS.include?(crt_name) && @router.try(:ovpn)
      send_data @router.crt_by_name(crt_name), filename: crt_name
    else
      render nothing: true, status: :unauthorized
    end
  end

  private

  def crt_name
    @crt_name ||= "#{params[:file]}.#{params[:format]}"
  end
end
