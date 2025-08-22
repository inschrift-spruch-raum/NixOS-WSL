{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];

  environment.systemPackages = with pkgs; [
    git
    wget
    #ntfs3g
  ];

  programs.nixvim.enable = true;
}