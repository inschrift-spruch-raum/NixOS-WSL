$source = Join-Path "$PSScriptRoot" "hosts"
$destination = "C:\Windows\System32\drivers\etc\hosts"
$backup = "C:\Windows\System32\drivers\etc\hosts.bak"
$temp = "C:\Windows\System32\drivers\etc\temp"

if (Test-Path "$backup") {
    Write-Host "hosts备份已存在,跳过修改"
    exit
}

(Get-Content -Path "$destination") + (Get-Content -Path "$source") | Set-Content -Path "$temp"
Rename-Item -Path "$destination" -NewName "hosts.bak"
Rename-Item -Path "$temp" -NewName "hosts"
