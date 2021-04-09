# Example 1: Hash Table with RegEx
Get-Content .\Config.txt | 
foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'=');
 if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } 
 }
Write-Host 'Example 1: Hash Table with RegEx -' $h.Color


# Example 2: Hash Table
$hashset = @{}
$dlm = '='
$settings = Get-Content .\Settings.ini
foreach($line in $settings)
    {
    $key = $line -split $dlm, 2
    #$hashset.Add($key[0],$key[1..($key.Length -1)] -join "=")
    $hashset.Add($key[0],$key[1])
    }
Write-Host 'Example 2: Hash Table -' $hashset.Color


# Example 3: JSON
$json = Get-Content .\config.json | ConvertFrom-Json -AsHashtable
Write-Host 'Example 3: JSON -' $json.Color


# Example 4: JSON with headings
$ConfigFile = '.\config2.json '
$HashConfig = Get-Content $ConfigFile | ConvertFrom-Json -AsHashtable
Write-Host 'Example 4: JSON with headings -' $HashConfig.Other.Color


