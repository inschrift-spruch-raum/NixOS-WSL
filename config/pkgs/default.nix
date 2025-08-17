{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];

  environment.systemPackages = with pkgs; [
    git
  ];

  programs.nixvim.enable = true;
}