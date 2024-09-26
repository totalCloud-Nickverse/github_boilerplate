{ pkgs, inputs, config, ...}:

{
    systemd.timers."${config.myApp.appName}-cd" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1m";
        OnUnitActiveSec = "1m";
        Unit = "${config.myApp.appName}-cd.service";
      };
    };


    systemd.services."${config.myApp.appName}-cd" = {
      description = "Continuous deployment for ${config.myApp.appName} website";
      path = [ pkgs.git ];
      script = ''
        git -C ${config.myApp.appName} config gc.autoDetach false
        if [ -d ${config.myApp.appHomeDir} ]; then
          git -C ${config.myApp.appName} fetch
          old=$(git -C ${config.myApp.appName} rev-parse @)
          new=$(git -C ${config.myApp.appName} rev-parse @{u})
          if [ $old != $new ]; then
            git -C ${config.myApp.appName} rebase --autostash
            echo "Updated from $old to $new"
          fi
        else
          git clone ${config.myApp.repoURL} ${config.myApp.appName}
          echo "Initialized at $(git -C ${config.myApp.appName} rev-parse @)"
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        WorkingDirectory = "${config.myApp.appHomeDir}";
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
