{ config, pkgs, ... }: {
  # grafana configuration
  services.grafana = {
    enable = true;
    settings.server = {
      http_port = 2342;
      http_addr = "${config.grafanaIP}";
    };
  };


  services.prometheus = {
    enable = true;
    port = 9001;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
    scrapeConfigs = [
      {
        job_name = "${config.thisHostname} scraper job";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
    ];
  };


}
