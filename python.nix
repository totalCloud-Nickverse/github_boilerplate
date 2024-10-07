#{ pkgs, ...}:
#let
#  python = pkgs.python312;
#in
#python.withPackages (ps: with ps; [
#  #django
#  #whitenoise    # for serving static files
#  #brotli        # brotli compression for whitenoise
#  #gunicorn      # for serving via http
#  #psycopg2      # for connecting to postgresql
#])
{ lib , config, pkgs, ... }:

{

config = {
  systemd.services."${config.appName}" = let
      djangoEnv = let
#        imagekit = pkgs.python3.pkgs.buildPythonPackage rec {
#          pname = "django-imagekit";
#          version = "4.0.2";
#  
#          src = pkgs.python3.pkgs.fetchPypi {
#            inherit pname version;
#            sha256 = "0370rqi0x2mafxckrrbczpni3lahyc7c3hlz7i2wslnzgjvszh3f";
#          };
#          
#          doCheck = false;
#
#          propagatedBuildInputs = [ pkgs.python3.pkgs.pilkit pkgs.python3.pkgs.six pkgs.python3.pkgs.django_appconf ];
#        };
      in
        (pkgs.python3.withPackages (ps: with ps; [ gunicorn django]));
    in {
      description = "Service test";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
#      preStart = ''
#        ${djangoEnv}/bin/python manage.py migrate;
#        #${djangoEnv}/bin/python manage.py collectstatic --no-input;
#      '';
      #preStart = ''
      #  ${djangoEnv}/bin/python manage.py runserver
      #'';
      serviceConfig = {
        WorkingDirectory = "${config.appHomeDir}";
        ExecStart = ''
          ${djangoEnv}/bin/gunicorn -b 0.0.0.0:8001 gunicorn_app_example:app
        '';
#        ExecStart = ''${djangoEnv}/bin/gunicorn \
#          --access-logfile \
#          - --workers 3 \
#          --bind unix:/var/www/acfunk/acfunk.sock \
#          acfunk.wsgi:application
#        '';
        Restart = "always";
        RestartSec = "10s";
        #StartLimitInterval = "1min";
        User = "admin";
      };
    };
  };
}







#buildPythonApplication {
#  pname = "${config.appName}";
#  version = "1.0";
#
#  propagatedBuildInputs = [ django gunicorn psycopg2 brotli whitenoise ];
#
#  src = ./.;
#}
