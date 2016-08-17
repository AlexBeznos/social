Superworker.define(:RouterSuperworker, :router_id) do
  # Vpn__ClientSetupWorker :router_id
  # Vpn__CertificatsMakingWorker :router_id
  # Vpn__CertificatsPullingWorker :router_id
  WifiRouter__LoginPageWorker :router_id
  WifiRouter__SettingsWorker :router_id
end
