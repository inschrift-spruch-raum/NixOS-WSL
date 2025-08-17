$source = Join-Path "$PSScriptRoot" ".wslconfig"
$destination = Join-Path "$env:UserProfile" ".wslconfig"
Copy-Item -Path "$source" -Destination "$destination" -Recurse
