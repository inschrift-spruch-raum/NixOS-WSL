$RootDir = Split-Path -Parent "$PSScriptRoot"

wsl --install --no-distribution
wsl --update
wsl --shutdown

$WSLRootDir = "$RootDir".Replace("C:\", "/mnt/c/").Replace("\", "/")

wsl sh "$WSLRootDir/make/WSL/WSLInit.sh"
wsl --shutdown
