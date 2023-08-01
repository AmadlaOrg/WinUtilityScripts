# Ensure WSL is shut down before proceeding
$wslStatus = (wsl --list --running).Trim()

if ($wslStatus -ne "No running distributions.") {
    Write-Output "Error: WSL distribution(s) are currently running. Please shut them down before proceeding. You can use the following command: `n`n wsl --shutdown `n"
    return
}

# Get all VHDX file paths
$vhdxPaths = Get-ChildItem -Path "$env:USERPROFILE\AppData\Local\Packages\" -Directory |
    Where-Object { 
        (Test-Path "$($_.FullName)\LocalState") -and ((Get-ChildItem "$($_.FullName)\LocalState\*.vhdx" -File).Count -gt 0)
    } |
    ForEach-Object {
        Get-ChildItem "$($_.FullName)\LocalState\*.vhdx" -File
    } |
    ForEach-Object {
        $_.FullName
    }

# Create an array of choice descriptions for the menu
$choices = @()
for ($i = 0; $i -lt $vhdxPaths.Count; $i++) {
    $choices += New-Object System.Management.Automation.Host.ChoiceDescription "&$i", "Optimize $($vhdxPaths[$i])"
}

# Display the menu and get the user's choice
$title = "Select a VHDX to optimize"
$message = "Enter the number of the VHDX file you want to optimize:"
$choice = $host.ui.PromptForChoice($title, $message, $choices, 0)

# Optimize the selected VHDX
Optimize-VHD -Path $vhdxPaths[$choice] -Mode Full
