{ config, pkgs, ... }:

{

  imports = [
    #./hardware-configuration.nix
    ./timers.nix
    ./redis.nix
    ./options.nix
    #./python.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  system.stateVersion = "22.05";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  networking.hostName = "${config.thisHostname}";

}
