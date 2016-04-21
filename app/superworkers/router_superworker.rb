Superworker.define(:RouterSuperworker, :router_id) do
  Vpn__ClientSetupWorker :router_id
  Vpn__CertificatsPullingWorker :router_id
  Router__LoginPageWorker :router_id
  Router__SettingsWorker :router_id
end
