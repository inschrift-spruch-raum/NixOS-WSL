#!/bin/bash

echo "Init start"

ScriptDir=$(cd $(dirname "$0") && pwd)

sudo nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable nixpkgs
sudo nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-25.05 nixos
sudo nix-channel --update
sudo nix-shell -p git --option substituters "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" --run "bash $ScriptDir/WSLMake.sh"