#!/bin/bash

echo "Make start"

ScriptDir=$(cd $(dirname "$0") && pwd)
RootDir=$(dirname $(dirname "$ScriptDir"))

cp -r "$RootDir/config" ~/NixOS-config
cd ~/NixOS-config

sudo nixos-rebuild switch --flake .#NixOS-WSL --option substituters "https://mirrors.cernet.edu.cn/nix-channels/store" --option download-buffer-size 268435456

rm -rf ~/NixOS-config
rm -rf /home/nixos
