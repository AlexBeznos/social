Superworker.define(:RouterSuperworker, :router_id) do
  Vpn__ClientSetupWorker :router_id
  Vpn__CertificatsPullingWorker :router_id
  RouterSettingsWorker :router_id
end
