function Write-Yellow ($Comment){

    Write-Host -Object $Comment -ForegroundColor Yellow
    }





$Pth = $PSScriptRoot

switch($pth){
{$_ -match 'c:'}{Write-Yellow -Comment (Get-Item $PSScriptRoot).Name
Set-Location (get-item $pth).PSParentPath
}
{$_ -match 'D:'}{Write-Yellow -Comment (Get-Item $PSScriptRoot).Name}
}

