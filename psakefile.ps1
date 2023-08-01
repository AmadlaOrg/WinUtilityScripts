properties {
    $scriptDir = Join-Path $env:USERPROFILE ".WinUtilityScripts"
}

task default -depends CreateScriptDir, AddDirToPath

task CreateScriptDir {
    if (-not (Test-Path $scriptDir)) {
        New-Item -ItemType Directory -Path $scriptDir | Out-Null
        Write-Output "Created directory: $scriptDir"
    } else {
        Write-Output "Directory already exists: $scriptDir"
    }
}

task AddDirToPath -depends CreateScriptDir {
    $path = [System.Environment]::GetEnvironmentVariable("Path", "User")

    if (-not ($path.Split(";") -contains $scriptDir)) {
        [System.Environment]::SetEnvironmentVariable("Path", "$path;$scriptDir", "User")
        Write-Output "Added $scriptDir to PATH"
    } else {
        Write-Output "$scriptDir is already in PATH"
    }
}
