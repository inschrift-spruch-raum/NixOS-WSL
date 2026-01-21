{ inputs, DefaultConfig, config, lib, pkgs, ... }:

{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  system.stateVersion = "26.05";

  wsl = {
    enable = true;
    defaultUser = "${DefaultConfig.UserName}";
    wslConf = {
      network.hostname = "${DefaultConfig.HostName}";
      user.default = "${DefaultConfig.UserName}";
    };
    usbip.enable = true;
    useWindowsDriver = true;
  };

  nix.settings = {
    experimental-features = "nix-command flakes";
    
    substituters = [ "https://mirrors.cernet.edu.cn/nix-channels/store" ];

    auto-optimise-store = true;

    trusted-users = [ "${DefaultConfig.UserName}" ];
  };

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "zh_CN.UTF-8";
}
