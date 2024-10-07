{ pkgs, inputs, config, ...}:

{
    systemd.timers."${config.appName}-cd" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1m";
        OnUnitActiveSec = "1m";
        Unit = "${config.appName}-cd.service";
      };
    };


    systemd.services."${config.appName}-cd" = {
      description = "Continuous deployment for '${config.appName}' website";
      path = [ pkgs.git ];
      script = ''
        git -C ${config.appHomeDir} config gc.autoDetach false
        if [ -d ${config.appHomeDir} ]; then
          git -C ${config.appHomeDir} fetch
          old=$(git -C ${config.appHomeDir} rev-parse @)
          new=$(git -C ${config.appHomeDir} rev-parse @{u})
          if [ $old != $new ]; then
            git -C ${config.appHomeDir} rebase --autostash
            echo "Updated from $old to $new"
          fi
        else
          git clone ${config.repoURL} ${config.appHomeDir}
          echo "Initialized at $(git -C ${config.appHomeDir} rev-parse @)"
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "admin";
        WorkingDirectory = "${config.appHomeDir}";
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
