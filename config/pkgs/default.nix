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
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings.features.cdi = true;
    daemon.settings.cdi-spec-dirs = ["/etc/cdi"];
  };

  systemd.tmpfiles.rules = [
    "d /etc/cdi 0755 root root -"
  ];

  systemd.services.nvidia-cdi-generate = {
    description = "Generate NVIDIA CDI specification for container runtime";
    
    wantedBy = ["multi-user.target"];
    
    before = ["docker.service"];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      
      Environment = "PATH=/run/current-system/sw/bin";
      
      ExecStart = ''
        ${pkgs.nvidia-container-toolkit}/bin/nvidia-ctk cdi generate \
          --mode=wsl \
          --output=/etc/cdi/nvidia.yaml \
          --library-search-path=/run/opengl-driver/lib
      '';
      
      User = "root";
      Group = "root";
      
      Restart = "on-failure";
      RestartSec = "5s";
      
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };

  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03*", \
      TAG+="systemd", ENV{SYSTEMD_WANTS}="nvidia-cdi-generate.service"
    
    ACTION=="add|change", SUBSYSTEM=="misc", KERNEL=="nvidia[0-9]*", \
      TAG+="systemd", ENV{SYSTEMD_WANTS}="nvidia-cdi-generate.service"
  '';

  systemd.services.docker.after = ["nvidia-cdi-generate.service"];
}