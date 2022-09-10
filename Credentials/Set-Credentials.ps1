param(
[Parmeter(Mandatory=$false)]
[ValidateSet('Domain','Local')]
$AccountType = 'Local'
)
if($AccountType -eq 'Local'){
    $AccountType = $env:COMPUTERNAME
    }
if($AccountType -eq 'Domain'){
    $AccountType = $env:USERDOMAIN
    }
$CredFile = '{0}\.PsCredentials\{1}-{2}' -f $env:USERPROFILE,$AccountType,$env:USERNAME
Get-Credential | Export-CliXml -Path $CredFile
$Credential = Import-CliXml -Path $CredFile