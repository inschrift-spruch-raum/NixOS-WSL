{ inputs, config, lib, pkgs, ... }:

let
  WSL-GPU-Libs = pkgs.callPackage ./WSLGPULibs.nix { };
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
      libraries = [ WSL-GPU-Libs ];
    };
    
    nixvim.enable = true;
  };

  hardware.nvidia.package = WSL-GPU-Libs;

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