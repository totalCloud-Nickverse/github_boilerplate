{config, lib, ...}: {
  options = {
    thisHostname = lib.mkOption {
      example = "whateva";
      type=lib.types.str;
    };

    redisOptions = {
      serverPort = lib.mkOption {
        example = 8084;
        type=lib.types.port;
      };
      serverName = lib.mkOption {
        example = "imsoReddi";
        type=lib.types.str;
      };
      slowMilliseconds = lib.mkOption {
        example = 100;
        default = 1000;
        type=lib.types.positive;
      };
      serverLogPath = lib.mkOption {
        default = "/var/log/redis.log";
        example = "/home/appUser/redis.log";
        type=lib.types.str;
      };
      serverLogLevel = lib.mkOption {
        example = "notice";
        default = "debug";
        type=lib.types.str;
      };
    };

    myApp = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({ config, lib, ... }: {
        options = {
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
        };
      }));
      description = "Set of options for the particular app to be deployed.";
      default = {};
    };
  };
}
