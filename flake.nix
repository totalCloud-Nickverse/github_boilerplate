{
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    agenix  = { url = "github:ryantm/agenix"; };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: rec {

#    appConfig = {
#      config.myApp = {
#        appName = "test";
#        appHomeDir = "/home/test/test";
#        repoURL = "lmao.lol.no";
#      };
#    };

    packages.x86_64-linux = {
      ami = inputs.nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        modules = [
          # you can include your own nixos configuration here, i.e.
          ./configuration.nix { config.myApp.appName = "test"; config.myApp.appHomeDir = "/test/test/test"; }
        ];
        format = "amazon";
        
        # optional arguments:
        # explicit nixpkgs and lib:
        # pkgs = nixpkgs.legacyPackages.x86_64-linux;
        # lib = nixpkgs.legacyPackages.x86_64-linux.lib;
        # additional arguments to pass to modules:
        # specialArgs = { myExtraArg = "foobar"; };
        
        # you can also define your own custom formats
        # customFormats = { "myFormat" = <myFormatModule>; ... };
        # format = "myFormat";
      };
    };

    nixosConfigurations = {
      someApp = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          [ # ...
            ./configuration.nix
	    inputs.agenix.nixosModules.default
          ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
