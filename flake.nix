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
    packages.x86_64-linux = {
      ami = inputs.nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        modules = [
           ({...}: { amazonImage.sizeMB = 60 * 1024; }) 
          ./configuration.nix { config.appName = "test"; config.appHomeDir = "/test/test/test"; config.repoURL = "nixos/doc/manual/development/option-types.section.md"; }
        ];
        format = "amazon";
        
        # optional arguments:
        # explicit nixpkgs and lib:
        # pkgs = nixpkgs.legacyPackages.x86_64-linux;
        # lib = nixpkgs.legacyPackages.x86_64-linux.lib;
        # additional arguments to pass to modules:
        # specialArgs = { myExtraArg = "foobar"; };
         specialArgs = { inherit inputs; diskSize = 20 * 1024; amazonImage.sizeMB = 20*1024; };
        
        # you can also define your own custom formats
        # customFormats = { "myFormat" = <myFormatModule>; ... };
        # format = "myFormat";
      };
    };

    nixosConfigurations = {
      someApp = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        #The grafanaIP is set to 0.0.0.0 here under the assumption that this configuration is running in
        #a local staging VM... Maybe it should somehow be set within virtualisation.vmVariant in configuration.nix
        modules =
          [ # ...
            ./configuration.nix { config.grafanaIP = "0.0.0.0" ; config.appName = "test"; config.appHomeDir = "/home/admin/test"; config.repoURL = "https://github.com/totalCloud-Nickverse/django-tester"; }
	    inputs.agenix.nixosModules.default
          ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
