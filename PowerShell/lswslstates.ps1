Get-ChildItem -Path "$env:USERPROFILE\AppData\Local\Packages\" -Directory | 
Where-Object { (Test-Path "$($_.FullName)\LocalState") -and ((Get-ChildItem "$($_.FullName)\LocalState\*.vhdx" -File).Count -gt 0) }
