{
  inputs = {
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs";
    
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, nur, home-manager, ... }: {
    nixosConfigurations = {
      NixOS-WSL = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "25.05";
            wsl.enable = true;
            wsl.defaultUser = "Raum";
            nix.settings = {
              substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
            };
          }
        ];
      };
    };
  };
}
