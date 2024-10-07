{config, lib, ...}: {
  options = {
    thisHostname = lib.mkOption {
      example = "whateva";
      type=lib.types.str;
      default = "testHostname";
    };

      redisServerPort = lib.mkOption {
        example = 8084;
        type=lib.types.port;
        default = 6379;
      };
      redisServerName = lib.mkOption {
        example = "imsoReddi";
        type=lib.types.str;
        default = "redisTestServer";
      };
      redisSlowMilliseconds = lib.mkOption {
        example = 100;
        default = 1000;
        type=lib.types.int;
      };
      redisServerLogPath = lib.mkOption {
        default = "/var/log/redis.log";
        example = "/home/appUser/redis.log";
        type=lib.types.str;
      };
      redisServerLogLevel = lib.mkOption {
        example = "notice";
        default = "debug";
        type=lib.types.str;
      };

    appName = lib.mkOption {
      default = "testApp";
      defaultText = "testText";
      description = "Name of the app, and also, the repo name";
      example = "bestInsuranceAppEver";
      type=lib.types.str;
    };
    appHomeDir = lib.mkOption {
      example = "/home/appuser/apphome";
      type=lib.types.str;
    };
    repoURL = lib.mkOption {
      example = "https://github.com/hopefullyNotARealUser/hopefullyNotARealRepo";
      type=lib.types.str;
    };
    serviceUser = lib.mkOption {
      default = "mrDjango";
      type=lib.types.str;
    };
  };
}
