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
{ lib , python3Packages }:
with python3Packages;
buildPythonApplication {
  pname = "exampleApp";
  version = "1.0";

  propagatedBuildInputs = [ django gunicorn psycopg2 brotli whitenoise ];

  src = ./.;
}
