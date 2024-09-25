{ pkgs, inputs, ...}:

{
  systemd.timers.${appName}-cd = {
  wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1m";
      OnUnitActiveSec = "1m";
      Unit = "${appName}-cd.service";
    };
};


    systemd.services.${appName}-cd = {
      description = "Continuous deployment for ${appName} website";
      path = [ pkgs.git ];
      script = ''
        git -C ${appName} config gc.autoDetach false
        if [ -d ${appName} ]; then
          git -C ${appName} fetch
          old=$(git -C ${appName} rev-parse @)
          new=$(git -C ${appName} rev-parse @{u})
          if [ $old != $new ]; then
            git -C ${appName} rebase --autostash
            echo "Updated from $old to $new"
          fi
        else
          git clone ${repoURL} ${appName}
          echo "Initialized at $(git -C ${appName} rev-parse @)"
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        WorkingDirectory = "/var/www";
      };
    };

    system.autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = [
        "--update-input"
        "nixpkgs"
        "-L" # print build logs
      ];
      dates = "02:00";
      randomizedDelaySec = "45min";
    };
}
