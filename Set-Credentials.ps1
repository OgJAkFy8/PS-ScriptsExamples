$CredFile = '{0}\{1}.cred' -f $env:USERPROFILE, $env:USERNAME
# $CredFile = '{0}.cred' -f $env:USERNAME
$Credential = Get-Credential | Export-CliXml -Path $CredFile
$Credential = Import-CliXml -Path $CredFile