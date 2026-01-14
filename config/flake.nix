{
  description = "NixOS-WSL Initialization Plan";

  inputs = {
    nixpkgs.url = "git+https://mirrors.cernet.edu.cn/nixpkgs.git?shallow=1";
    
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
        url = "github:nix-community/nixvim";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, nixvim, ... } @inputs:
  let
    DefaultConfig = {
      UserName = "Raum";
      HostName = "NixOS";
    };
  in {
    nixosConfigurations = {
      NixOS-WSL = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs DefaultConfig;};
        modules = [
          ./system
          ./pkgs
        ];
      };
    };
  };
}
