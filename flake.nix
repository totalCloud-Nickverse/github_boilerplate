{
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    agenix  = { url = "github:ryantm/agenix"; };
  };
  outputs = inputs: rec {
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
