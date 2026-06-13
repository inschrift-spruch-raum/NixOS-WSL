{ inputs, config, lib, pkgs, ... }:

let
  wl-WSL-clipboard = pkgs.callPackage ./wl-WSL-clipboard.nix { };
in
{
  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wl-WSL-clipboard
    cudaPackages.cudatoolkit
    nvidia-container-toolkit
    nvidia-container-toolkit.tools
    git
    wget
  ];

  programs = {
    nix-ld = {
      enable = true;
      libraries = [
        config.wsl.wslLib
      ];
    };
    
    nixvim.enable = true;
  };

  # https://github.com/nix-community/NixOS-WSL/issues/716#issuecomment-3761151768
  hardware.nvidia.package = config.wsl.wslLib;

  nixpkgs.config = {
    cudaSupport = true;
    cudaForwardCompat = true;
  };

  hardware.nvidia-container-toolkit = {
    enable = true;
    mount-nvidia-executables = false;
    suppressNvidiaDriverAssertion = true;
    disable-hooks = [];
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings.features.cdi = true;
  };
}