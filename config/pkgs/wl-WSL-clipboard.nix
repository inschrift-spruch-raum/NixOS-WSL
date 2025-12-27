# https://codeberg.org/oricat/nix-workstation/src/branch/main/hosts/wsl/wl-clipboard-win.nix
# 因为作者曾经向 NixOS-WSL 提供过这段代码,因此我将这段代码视为以 NixOS-WSL 的 Apache-2.0 进行授权

{ stdenv, writeShellScriptBin, pkgs }:

let
  wl-copy = writeShellScriptBin "wl-copy" ''
    printf '%s' "$(cat)" | ${pkgs.dos2unix}/bin/unix2dos | clip.exe
  '';

  wl-paste = writeShellScriptBin "wl-paste" ''
    powershell.exe -command Get-Clipboard | ${pkgs.dos2unix}/bin/dos2unix
  '';
in

stdenv.mkDerivation {
  name = "wl-WSL-clipboard";
  version = "1.0";
  buildInputs = [ wl-copy wl-paste ];
  src = ./.;
  installPhase = ''
    mkdir -p $out/bin
    ln -s ${wl-copy}/bin/wl-copy $out/bin/wl-copy
    ln -s ${wl-paste}/bin/wl-paste $out/bin/wl-paste
  '';
}
