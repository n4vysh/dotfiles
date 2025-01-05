{ pkgs, inputs, ... }:

{
  home = {
    username = "n4vysh";
    homeDirectory = "/home/n4vysh";

    stateVersion = "24.11";
  };

  home.packages = [
    pkgs.statix
    pkgs.deadnix

    inputs.hyprland-contrib.packages.${pkgs.system}.scratchpad
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast

    # NOTE: nixd not support by mason-lspconfig
    # https://github.com/williamboman/mason-lspconfig.nvim/issues/390
    inputs.nixd.packages.${pkgs.system}.nixd
  ];

  programs.home-manager.enable = true;
}
