#!/bin/bash

echo "Init start"

ScriptDir=$(cd $(dirname "$0") && pwd)

sudo nix-channel --add https://mirrors.cernet.edu.cn/nix-channels/nixpkgs-unstable nixpkgs
sudo nix-channel --add https://mirrors.cernet.edu.cn/nix-channels/nixos-25.11 nixos
sudo nix-channel --update
sudo nix-shell --extra-experimental-features "nix-command flakes" -p git --option substituters "https://mirrors.cernet.edu.cn/nix-channels/store" --run "bash $ScriptDir/WSLMake.sh"
