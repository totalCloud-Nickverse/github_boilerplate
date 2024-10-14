{ config, pkgs, ... }:

{

  imports = [
    #./hardware-configuration.nix
    ./timers.nix
    ./redis.nix
    ./options.nix
    #./python.nix
    ./visibility.nix
    #TODO:
    #the following line is needed for virtualisation.forwardPorts to be recognized,
    #and also why --impure is needed in the buildCommand. Need to fix this to make it pure.
    <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix> 
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  #REMOVE BEFORE PUTTING INTO PRODUCTION
  users.groups.admin = {};
  users.groups."${config.serviceUser}" = {};
  users.users = {
    admin = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      password = "admin";
      group = "admin";
    };
    "${config.serviceUser}" = {
      isSystemUser = true;
      extraGroups = [ "wheel" ];
      group = config.serviceUser;
    };
  };

  services.postgresql = {
    enable = true;
  };

  virtualisation = {
    vmVariant = {
      # following configuration is added only when building VM with build-vm
      virtualisation = {
        memorySize = 2048; # Use 2048MiB memory.
        cores = 3;
        graphics = false;
      };
    };

    #referred to: https://www.reddit.com/r/NixOS/comments/1as9gdy/local_development_environment_to_set_up_multiple/
    forwardPorts = [
      { from = "host"; host.port = 8976; guest.port = 8000; }
      { from = "host"; host.port = 9999; guest.port = 8001; }
      { from = "host"; host.port = 12345; guest.port = 2342; }
    ];
  };

  #needed to connect from the host machine
  networking.firewall = {
    allowedTCPPorts = [ 8000 8001 2342];
    allowedUDPPorts = [ 8000 8001 2342];
  };


  system.stateVersion = "24.11";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  networking.hostName = "${config.thisHostname}";

}
