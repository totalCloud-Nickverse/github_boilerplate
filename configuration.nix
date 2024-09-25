{ config, pkgs, ... }:

{

  imports = [
    ./hardware-configuration.nix
    ./timers.nix
  ];

  environment.systemPackages = with pkgs; [
    python3
    vim
    git
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  system.stateVersion = "22.05";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  networking.hostName = "someApp";

}
