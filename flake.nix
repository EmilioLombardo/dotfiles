{
  description = "Home Manager configuration of Emilio";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    in
    {
      homeConfigurations."emilio" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          # Attributes defined in here will be passed as arguments to the
          # modules below, e.g. home.nix
          inherit pkgs-unstable;
        };
        modules = [ ./home.nix ];
      };
    };
}
