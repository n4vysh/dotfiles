{
  description = "Home Manager configuration of n4vysh";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NOTE: nixd not support by mason-lspconfig
    # https://github.com/williamboman/mason-lspconfig.nvim/issues/390
    nixd = {
      url = "github:nix-community/nixd";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@ inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."n4vysh" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ ./home.nix ];

        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };
}
