{ inputs, config, lib, pkgs, ... }:

let
  WSL-GPU-Libs = pkgs.callPackage ./WSLGPULibs.nix { };
  WSL-clipboard = pkgs.callPackage ./WSL-clipboard.nix { };
in
{
  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    WSL-clipboard
  ];

  programs = {
    nix-ld = {
      enable = true;
      libraries = [ WSL-GPU-Libs ];
    };
    
    nixvim.enable = true;
  };
}
