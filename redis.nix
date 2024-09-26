{ config, ...}:
{
  services = {
    redis = {
      servers = {
        "${config.redisOptions.serverName}" = {
          enable = true;
          port = config.redisOptions.serverPort;
          slowLogLogSlowerThan = config.redisOptions.slowMilliseconds;
          logfile = config.redisOptions.serverLogPath;
          
        };
      };
    };
  };
}
