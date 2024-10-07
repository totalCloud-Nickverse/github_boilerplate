{ config, ...}:
{
  services = {
    redis = {
      servers = {
        "${config.redisServerName}" = {
          enable = true;
          port = config.redisServerPort;
          slowLogLogSlowerThan = config.redisSlowMilliseconds;
          logfile = config.redisServerLogPath;
          
        };
      };
    };
  };
}
