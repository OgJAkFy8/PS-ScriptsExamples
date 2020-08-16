<#$Credential = Get-Credential
$Credential | Export-CliXml -Path .\Jaap.Cred
$Credential = Import-CliXml -Path .\Jaap.Cred
#>

$MenuObject = 'System.Management.Automation.Host.ChoiceDescription'
$red1 = New-Object -TypeName $MenuObject -ArgumentList '&Red1', 'Favorite color: Red1'
$blue1 = New-Object -TypeName $MenuObject -ArgumentList '&Blue1', 'Favorite color: Blue1'
$yellow1 = New-Object -TypeName $MenuObject -ArgumentList '&Yellow1', 'Favorite color: Yellow1'
$red2 = New-Object -TypeName $MenuObject -ArgumentList '&Red2', 'Favorite color: Red2'
$blue2 = New-Object -TypeName $MenuObject -ArgumentList '&Blue2', 'Favorite color: Blue2'
$yellow2 = New-Object -TypeName $MenuObject -ArgumentList '&Yellow2', 'Favorite color: Yellow2'
$red3 = New-Object -TypeName $MenuObject -ArgumentList '&Red3', 'Favorite color: Red3'
$blue3 = New-Object -TypeName $MenuObject -ArgumentList '&Blue3', 'Favorite color: Blue3'
$yellow3 = New-Object -TypeName $MenuObject -ArgumentList '&Yellow3', 'Favorite color: Yellow3'
$red4 = New-Object -TypeName $MenuObject -ArgumentList '&Red4', 'Favorite color: Red4'
$blue4 = New-Object -TypeName $MenuObject -ArgumentList '&Blue4', 'Favorite color: Blue4'
$yellow4 = New-Object -TypeName $MenuObject -ArgumentList '&Yellow4', 'Favorite color: Yellow4'
 
$options = [System.Management.Automation.Host.ChoiceDescription[]]($red1, $blue1, $yellow1,$red2, $blue2, $yellow2,$red3, $blue3, $yellow3,$red4, $blue4, $yellow4)


$title = 'Favorite color'
$message = 'What is your favorite color?'
$result = $host.ui.PromptForChoice($title, $message, $options, 0)

Write-Output $result