{ inputs, DefaultConfig, config, lib, pkgs, ... }:

{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  system.stateVersion = "25.05";

  wsl = {
    enable = true;
    defaultUser = "${DefaultConfig.UserName}";
    wslConf = {
      network.hostname = "${DefaultConfig.HostName}";
      user.default = "${DefaultConfig.UserName}";
    };
  };

  nix.settings = {
    experimental-features = "nix-command flakes";
    
    substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
  };
  
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "zh_CN.UTF-8";
}